const express = require('express')
const mysql = require('mysql')
const app = express()

const port = process.env.APP_PORT
const connection = mysql.createConnection({
  host     : process.env.MYSQL_HOST,
  user     : process.env.MYSQL_USER,
  password : process.env.MYSQL_PASSWORD,
  database : process.env.MYSQL_DATABASE
})

app.get('/api/get/:name', (req, res) => {
  const { name } = req.params
  connection.query({
    sql: 'SELECT * from `pet` where `name` = ? LIMIT 1;',
    values: [name]
  }, function (error, results) {
    if (error) {
      res.status(500).json({error: error.message})
    } else if (results.length === 0) {
      res.status(404).json({error: "Not found"})
    } else {
      const [row] = results
      res.status(200).json({...row, sex: row.sex == '1'})
    }
  });
})


// Start web server
const server = app.listen(port, () => {
  // Open mysql connection
  connection.connect(err => {
    if (err) {
      console.warn('Error to connect to database', err)
    } else {
      console.log(`HTTP server listening at http://localhost:${port}`)
    }
  })
})

// Listen exit signal
const handleSignals = (signal) => {
  console.log(`${signal} signal received`)
  // Close http server
  server.close(serverError => {
    if (serverError) {
      console.warn('Error to close server', serverError)
    } else {
      console.log('Successfully closed HTTP server')
    }

    // Close mysql connection
    connection.end(connectionError => {
      if (connectionError) {
        console.warn('Error to disconnect from database', connectionError)
      } else {
        console.log('Successfully closed db connection')
      }
    })

  })
}

process.on('SIGTERM', handleSignals)
process.on('SIGINT', handleSignals)
process.on('beforeExit', handleSignals)