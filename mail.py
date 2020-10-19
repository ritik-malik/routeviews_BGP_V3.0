import smtplib, ssl, sys

message = sys.argv[1]
EMAIL = "t.wellick404@gmail.com"
PASSWD = "konhaituBC$69"
RECEIVER = "ritikmaalik2000@gmail.com"

port = 587  # For starttls
smtp_server = "smtp.gmail.com"
sender_email = EMAIL
receiver_email = RECEIVER
password = PASSWD

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message)
