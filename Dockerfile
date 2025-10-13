# Use an official Python runtime as a build stage image
FROM python:3.13.0-slim AS build1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container to install the dependencies
COPY requirements.txt requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip install --user --no-cache-dir -r requirements.txt

# Use another stage to copy only the necessary files and the installed packages
FROM python:3.13.0-slim AS build2

# Set the working directory in the container
WORKDIR /app

# Copy the installed packages from the previous stage
COPY --from=build1 /root/.local/ /root/.local/

# Ensure the installed packages are in the PATH
ENV PATH=/root/.local/bin:$PATH

#copy the current directory contents into the container at /app
COPY . /app

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define the command to be run when the container starts
CMD [ "python", "run.py" ]