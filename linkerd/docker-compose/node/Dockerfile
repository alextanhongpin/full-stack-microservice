FROM node:boron
COPY server.js package.json /app/
RUN npm install /app/
CMD ["node", "/app/server.js"]