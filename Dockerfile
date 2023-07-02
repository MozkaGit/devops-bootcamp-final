FROM python:3.6-alpine
LABEL maintainer="mozka@gmail.com"
RUN pip install flask==1.1.2
WORKDIR /opt
COPY /app/app.py .
COPY /app/templates ./templates
COPY /app/static ./static
EXPOSE 8080
ENV ODOO_URL=https://www.odoo.com/
ENV PGADMIN_URL=https://www.pgadmin.org/
ENTRYPOINT ["python"]
CMD ["/opt/app.py"]
