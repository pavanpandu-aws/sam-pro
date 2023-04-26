FROM node:latest

# Create app directory
WORKDIR /home/ubuntu/clumsy

# Install app dependencies
COPY package*.json ./
RUN npm install
RUN npm install -g grunt-cli liftup

# Bundle app source
COPY . .

EXPOSE 8000

CMD ["grunt", "connect"]
