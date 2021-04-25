# Docker Framadate

A Dockerfile for [Framadate](https://framagit.org/framasoft/framadate).

## Run

```bash
docker exec -d \
            -e SERVERNAME: localhost \
            -e ADMIN_PASSWORD: admin \
            -e APP_NAME=Framadate \
            -e EMAIL_ADRESS=noreply@example.org \
            -e DB_HOST=db \
            -e DB_NAME=framadate \
            -e DB_USER=framadate \
            -e DB_PASSWORD=password \
            -e SMTP_HOST=smtp.example.com \
            -e SMTP_AUTH=true \
            -e SMTP_USERNAME=admin \
            -e SMTP_PASSWORD=admin \
            -e SMTP_SECURE=tls \
            -e SMTP_PORT=587 \
            -e SHOW_WHAT_IS_THAT=true \
            -e SHOW_THE_SOFTWARE=true \
            -e SHOW_CULTIVATE_YOUR_GARDEN=true \
            -e DEFAULT_POLL_DURATION=365 \
            -e USER_CAN_ADD_IMG_OR_LINK=true \
            -e MARKDOWN_EDITOR_BY_DEFAULT=true \
            -e PROVIDE_FORK_AWESOME=true \
            -p 8080:80 \
            xgaia/framadate
```

## Configure

Go to [localhost:8080/admin](http://localhost:8080/admin) and run database migration.
