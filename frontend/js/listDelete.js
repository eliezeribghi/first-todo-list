 async function handleDelete(event){

const div=event.target
//selectionner
const removeElement = event.target.parentNode;
//recup
const removeId = removeElement.dataset.id;
//suppression  
if(div.classList.contains('delete') ) {
   await deleteElementFromApi(removeId);
    removeElement.remove();
}


};

async function deleteElementFromApi(id) {
   
    await fetch(apiConfig.endpoint + '/tasks/' + id,{ method: 'DELETE'});

}

function deleteListener(){
    const ul=document.querySelector('.tasklist');
    ul.addEventListener('click', handleDelete);
}
deleteListener(); 