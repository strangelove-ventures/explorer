FROM node:19-alpine3.16 as builder
LABEL org.opencontainers.image.source="https://github.com/strangelove-ventures/explorer"
WORKDIR /app
COPY . .
RUN yarn --ignore-engines && yarn build

# Bundle static assets with nginx
FROM nginx:1.23.3-alpine as production
ENV NODE_ENV production
# Copy built assets from `builder` image
COPY --from=builder /app/dist /usr/share/nginx/html
# Add your nginx.conf
COPY ping.conf /etc/nginx/conf.d/default.conf
# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
