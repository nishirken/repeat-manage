#! /usr/bin/env node
const Koa = require('koa');
const fs = require('fs');
const serve = require('koa-static');

const app = new Koa();

app.use(ctx => {
  if (ctx.request.url === '/') {
    ctx.type = 'text/html';
    ctx.body = fs.readFileSync('./custom.html', { encoding: 'UTF8' });
  } else if (ctx.request.url === '/dist/elm.js') {
    ctx.type = 'application/javascript';
    ctx.body = fs.readFileSync('./dist/elm.js', { encoding: 'UTF8' });
  } else {
    ctx.status = 404;
  }
});

app.listen(3000);
console.log('Server started at http://localhost:3000');
