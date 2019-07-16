let url = 'http://localhost:3000/customers';
// let url = 'https://mundipagg-api.herokuapp.com/customers';

fetch(url, {
  method: 'POST',
  headers:{
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    operacao: {
      tipo: 'list',
      objeto: 'customer',
      // api_key: 'sk_test_Your_Secret_Key' 
    }
    })
  }).then((resp) => resp.json())
    .then((data) => {
      document.getElementById("demo").insertAdjacentHTML('beforebegin', JSON.stringify(data));
    })
    .catch(err => {
    alert("ERROR: " + err.toString());
});
