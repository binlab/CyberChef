FROM node:10.24.0-alpine3.11 AS builder

RUN mkdir /node

WORKDIR /node

ADD . .

RUN chown -R node:node .

# https://github.com/gchq/CyberChef/issues/1162
USER node

RUN node --version \
    && npm --version \
    && npm install \
    && npm run setheapsize \
    && npx grunt prod


FROM nginx:1.19.8-alpine AS release

LABEL maintainer="Mark Binlab <mark.binlab@gmail.com>"

COPY --from=builder /node/build/prod /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
