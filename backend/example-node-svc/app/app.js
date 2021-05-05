const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello Kubify!')
})

app.listen(port, () => {
  console.log(`Example kubify app listening at http://localhost:${port}`)
})