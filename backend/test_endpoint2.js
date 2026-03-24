const http = require('http');

http.get('http://localhost:5000/api/attendance/daily?date=2026-03-24', (res) => {
  let body = '';
  res.on('data', chunk => body += chunk);
  res.on('end', () => {
    const data = JSON.parse(body);
    console.log(`Found ${data.length} members.`);
    if (data.length >= 2) {
      console.log('Sending update for member 1:', data[0].memberId);
      sendUpdate(data[0].memberId, 'Present', () => {
        console.log('Sending update for member 2:', data[1].memberId);
        sendUpdate(data[1].memberId, 'Absent', () => {
          console.log('Done!');
        });
      });
    }
  });
});

function sendUpdate(memberId, status, cb) {
  const postData = JSON.stringify({ memberId, date: '2026-03-24', status });
  const req = http.request({
    hostname: 'localhost',
    port: 5000,
    path: '/api/attendance/update',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': postData.length
    }
  }, (res) => {
    let b = '';
    res.on('data', chunk => b+=chunk);
    res.on('end', () => {
      console.log('Status:', res.statusCode, b);
      if(cb) cb();
    });
  });
  req.write(postData);
  req.end();
}
