# The pulled image from DockerHub
FROM python:3.9-alpine3.13

# Labelling the name of the maintainer of this image
LABEL maintainer="LeSaumon"

# Mandatory to get Python run nicely on container / limit the delay between the container and the application
ENV PYTHONBUFFERED 1

# Copy the requirements.txt inside a /tmp/ directory in container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the contant of ./app to a /app in container
COPY ./app /app

# Select the directory where all of our commands will be executed
WORKDIR /app

# Expose the conainer to the 8000 port
EXPOSE 8000

# Create an arguments that will be overrided only when docker-compose the app
ARG DEV=false

# This is a bloc of commands that will be executed when we are building the image
RUN python -m venv /py && \
    # install and ugrade pip
    /py/bin/pip install --upgrade pip && \
    # tell pip to install all the dependencies of requirements.txt
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Condition to install the requirements.dev.txt
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # This is to delete the tmp directory
    rm -r /tmp && \
    # Add a new user to the user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Update the PATH variable inside the container
ENV PATH="/py/bin:$PATH"

USER django-user