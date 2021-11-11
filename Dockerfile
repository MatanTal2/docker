FROM node:14.18

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# copy package.jason to src folder
COPY package*.json /usr/src/app
 
RUN npm install

COPY . /usr/src/app
# opne port 8080 to outside
EXPOSE 8080
# run the application
CMD ["npm", "run", "dev"]