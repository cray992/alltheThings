import requests
import pymssql
import yaml
import socket


url = 'https://api.fivetran.com/v1/connectors'
warehouse_url = 'https://api.fivetran.com/v1/groups'


def load_config(filename):
    with open(filename, 'r') as yaml_file:
        cfg = yaml.load(yaml_file, Loader=yaml.FullLoader)
    return cfg


config = load_config('config.yml')
access_id = config['fivetran_api']['id']
access_secret = config['fivetran_api']['key']


def get_customer_db_port(server_name):
    return 4700 + int(server_name[-2:])


def get_warehouses():
    warehouses = {}
    response = requests.get(warehouse_url, auth=(access_id, access_secret))
    for w in response.json()['data']['items']:
        warehouses[w['name']] = w['id']
    return warehouses


def get_customers():
    shared_db = config['shared_db']
    conn = pymssql.connect(
        server=shared_db['host'],
        port=shared_db['port'],
        user=shared_db['user'],
        password=shared_db['password'],
        database=shared_db['db'],
    )
    cursor = conn.cursor(as_dict=True)
    cursor.execute(config['customer_query'])
    customers = cursor.fetchall()
    conn.close()
    return customers


def main():
    warehouses = get_warehouses()
    print(warehouses)
    return
    customers = get_customers()
    for customer in customers:
        instance_name = customer['server'].split('-')[-1].upper()
        group_id = warehouses.get(instance_name)
        if not group_id:
            print('Could not find warehouse for instance: {}'.format(instance_name))
            continue
        connector_config = config['connector_config']
        connector_config['group_id'] = group_id
        customer_id = customer['db'].split('_')[1]
        db_server = customer['server']
        db_ip = socket.gethostbyname(db_server + '.kareoprod.ent')
        connector_config['config']['schema_prefix'] = 'kid{}'.format(customer_id)
        connector_config['config']['database'] = customer['db']
        connector_config['config']['host'] = db_ip
        if config['generate_db_port']:
            connector_config['config']['port'] = get_customer_db_port(customer['server'])
        response = requests.post(url, json=connector_config, auth=(access_id, access_secret))
        response_data = response.json()
        if not response.ok:
            if 'message' in response_data:
                print(response_data['message'])
            else:
                print('Connector creation failed for kid: {}'.format(customer_id))
                print(response.content)
            continue
        # start connector
        connector_id = response.json()['data']['id']
        schedule_data = {
            "paused": False,
            "sync_frequency": 360,
            "schedule_type": "auto"
        }
        schedule_url = 'https://api.fivetran.com/v1/connectors/{}'.format(connector_id)
        response = requests.patch(schedule_url, json=schedule_data, auth=(access_id, access_secret))
        if not response.ok:
            if 'message' in response_data:
                print(response_data['message'])
            else:
                print('Connector schedule setup failed for kid: {}'.format(customer_id))
                print(response.content)
        print('Connector created and scheduled for kid: {}'.format(customer_id))


if __name__ == '__main__':
    main()
