#!/usr/bin/env node

import {createServer} from 'http';
import {join} from 'path';
import {readFileSync as read} from 'fs';

var port = process.argv[2] || 1337
  , pages = ['/', '/index.html', '/advanced', '/troubleshooting']
  , files = {
      '/': {
          mime: 'text/html'
        , data: read( join(__dirname, 'index.html') )
      }
      , '/slackomatic.appcache': {
          mime: 'text/plain'
        , data: read( join(__dirname, 'slackomatic.appcache') )
      }
      , '/favicon.ico': {
          mime: 'image/x-icon'
        , data: read( join(__dirname, 'favicon.ico') )
      }
      , '/img/cleanup_reminder.jpg': {
          mime: 'image/jpg'
        , data: read( join(__dirname, 'img', 'cleanup_reminder.jpg') )
      }
      , '/img/power_down_warning.png': {
          mime: 'image/png'
        , data: read( join(__dirname, 'img', 'power_down_warning.png') )
      }
    }
;

var server = createServer( (req, res) => {
  var data = files[req.url];

  if ( req.url === '/killkillkill' ) {
    return process.exit();
  }

  if ( pages.indexOf(req.url) > -1 && ! data ) {
    data = files['/'];
  }

  if ( data && data.data && data.mime ) {
    res.writeHead(200, {'Content-Type': data.mime});
    res.end(data.data);
  } else {
    res.writeHead(301, {
      Location: '/'
    });
    res.end(); 
  }
});

server.listen(port);

console.log(`Servomatic listening to port ${port}`);
