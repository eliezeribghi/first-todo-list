FROM node:18-alpine

WORKDIR /home/node/app
COPY package.json package-lock.json ./
RUN npm install
COPY js/ ./js/
RUN npm run build
COPY index.js ./
COPY index.html ./
COPY css/ ./css/
COPY dist/ ./dist/
CMD ["npm", "start"]