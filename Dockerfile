# install node
FROM node:16.3.0-alpine

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install --legacy-peer-deps

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# serve application in development
CMD [ "npm", "run", "serve"]