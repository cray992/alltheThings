import smtplib
from email.mime.text import MIMEText


class Emailer(object):
    DEFAULT_SENDER = 'no-reply@kareo.com'

    def __init__(self, smtp_server='smtp.kareo.com'):
        self.server = smtplib.SMTP(smtp_server)
        self.server.set_debuglevel(1)

    def __del__(self):
        self.server.quit()

    def send_email(self, to, body, subject=None):
        """

        :param: to: Comma separated string of email addresses
        :type to: str
        :type body: str
        :type subject: str
        :rtype: None
        """
        msg = MIMEText(body)
        if subject:
            msg['Subject'] = subject

        msg['From'] = Emailer.DEFAULT_SENDER
        emails = [email.strip() for email in to.split(",")]
        self.server.sendmail(Emailer.DEFAULT_SENDER, emails, msg.as_string())
