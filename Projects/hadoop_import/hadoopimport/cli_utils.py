import os
import time
from subprocess import call
from tempfile import NamedTemporaryFile
from config import Config

config = Config()
logger = config.get_logger(__package__)

USER = os.environ["USER"]
HADOOP_IMPORT_HOME = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HADOOP_JOB_DIR_TEMPLATE = "/tmp/%s/%s/%s"


def execute_shell_command(command):
    logger.debug("Execute shell command: %s" % command)
    return call(command, shell=True)


def execute_shell_with_output(command):
    """
    Execute the external command and return output in an array of strings for each line returned
    :type command: str
    :rtype: str
    """
    logger.debug("Execute with output shell command: %s" % command)
    outputs = os.popen(command).readlines()
    outputs = [output.strip('\n') for output in outputs]
    return outputs


def copy_file_to_hdfs(file_path, hdfs_path):
    logger.debug("Copying file: %s to hdfs: %s" % (file_path, hdfs_path))

    execute_shell_command("hadoop fs -put {0} {1}".format(file_path, hdfs_path))
    give_permissions_to_hdfs(hdfs_path)
    give_permissions_to_temp()

def give_permissions_to_hdfs(hdfs_path):
    execute_shell_command("hadoop fs -chmod -R 777 {0}".format(hdfs_path))

def give_permissions_to_temp():
    execute_shell_command("hadoop fs -chmod -R 777 /tmp/" + USER)


def read_file_from_hdfs(hdfs_path):
    logger.debug("Reading file: %s from hdfs" % (hdfs_path))
    return execute_shell_with_output("hadoop fs -cat {0}".format(hdfs_path))


def create_temp_file(prefix, lines):
    """
    :type prefix: str
    :type lines: list of str
    :rtype: NamedTemporaryFile
    """
    ntf = NamedTemporaryFile(prefix="db_batch_")
    for line in lines:
        ntf.write(line + "\n")

    ntf.seek(0)

    logger.debug("CREATING TEMP FILE: " + str(ntf.name))
    return ntf


def create_target_folder():
    logger.debug("Create target folder")
    # Target folder to put all "compiled" packages
    execute_shell_command("mkdir -p %s/target" % HADOOP_IMPORT_HOME)


def generate_hadoopimport_zip():
    logger.debug("Generate Hadoop import zip")
    execute_shell_command(("cd %s/hadoopimport; zip -qr ../target/hadoopimport . " +
                           "--exclude hadoopimport/tests/\\* --exclude *.pyc")
                          % HADOOP_IMPORT_HOME)


def generate_etl_zip():
    logger.debug("Generate ETL zip")
    execute_shell_command("cd %s/etl; zip -qr ../target/etl . " % HADOOP_IMPORT_HOME)


def get_hadoopimport_home():
    logger.debug("Get HadoopImport home: %s" % HADOOP_IMPORT_HOME)
    return HADOOP_IMPORT_HOME


def build_hadoopimport():
    logger.debug("Build HadoopImport")
    create_target_folder()
    generate_hadoopimport_zip()


def create_hdp_unique_job_folder(job_name):
    logger.debug("Create HDP unique job folder: %s" % job_name)
    now = time.strftime("%Y-%m-%d_%H_%M_%S")
    hdp_job_dir = HADOOP_JOB_DIR_TEMPLATE % (USER, job_name, now)

    # Create a unique hadoop folder using the current time
    execute_shell_command("hadoop fs -mkdir -p %s" % hdp_job_dir)
    execute_shell_command("hadoop fs -touchz %s/input.txt" % hdp_job_dir)

    logger.debug("HDP job dir: %s" % hdp_job_dir)
    return hdp_job_dir

