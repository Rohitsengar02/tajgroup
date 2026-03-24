const dns = require('dns');

dns.resolveSrv('_mongodb._tcp.tahproject.zpsseb5.mongodb.net', (err, addresses) => {
  if (err) {
    console.error('SRV Resolution Error:', err);
  } else {
    console.log('SRV Records Found:', addresses);
  }
});
