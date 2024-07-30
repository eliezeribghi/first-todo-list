const apiConfig = {
    endpoint: 'http://localhost:8000/api'

}

let response =  fetch('http://localhost:8000/api/task');
console.log(response);