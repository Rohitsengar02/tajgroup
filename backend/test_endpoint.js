const http = require('http');

const data = JSON.stringify({
  memberId: "somejunkid",
  date: "2026-03-24",
  status: "Present"
});

const req = http.request({
  hostname: 'localhost',
  port: 5000,
  path: '/api/attendance/update',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
}, (res) => {
  let body = '';
  res.on('data', chunk => body += chunk);
  res.on('end', () => console.log('Response:', res.statusCode, body));
});

req.on('error', e => console.error(e));
req.write(data);
req.end();
