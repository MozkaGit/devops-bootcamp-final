FROM python:3.6-alpine
LABEL maintainer="mozkadevops@gmail.com"
RUN pip install flask==1.1.2
WORKDIR /opt
COPY app.py .
COPY templates ./templates
COPY static ./static
EXPOSE 8080
ENV ODOO_URL=http://Odoo_Web:8080
ENV PGADMIN_URL=http://Pgadmin:5050
ENTRYPOINT ["python"]
CMD ["/opt/app.py"]