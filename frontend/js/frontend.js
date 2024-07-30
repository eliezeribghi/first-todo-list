async function task() {
    try {
        const response = await fetch('http://localhost:8000/api/task');
        if (!response.ok) {
            throw new Error('Erreur lors de la récupération des données');
        }
        const data = await response.json();
        for (const task of data) {
            insertTaskInDom(task);
        }
    } catch (error) {
        console.error('Une erreur est survenue:', error);
    }
}

async function insertTaskInDom(task) {
 
    const liElement = document.createElement('li');
    liElement.setAttribute("data-id", task.id);

    const pElement = document.createElement('p');
    pElement.textContent = `ID: ${task.id} - ${task.title}`;

    const divDeleteElement = document.createElement('div');
    divDeleteElement.classList.add('delete');
    divDeleteElement.setAttribute("data-id", task.id);

    const divEditElement = document.createElement('div');
    divEditElement.classList.add('edit');

    liElement.append(pElement);
    liElement.append(divDeleteElement);
    liElement.append(divEditElement);
    document.querySelector('.tasklist').append(liElement);
}

async function deleteTask(elementList) {
    try {
        let id = elementList.getAttribute('data-id');
        await fetch(`http://localhost:8000/api/task/${id}`, { method: "DELETE" });
        elementList.parentNode.remove();
        const successMessage = document.querySelector('.message.success');
        successMessage.style.display = 'block';
        setTimeout(function() {
            successMessage.style.display = 'none';
        }, 3000);
    } catch (error) {
        console.error('Erreur lors de la suppression de la tâche:', error);
        const errorMessage = document.querySelector('.message.danger');
        errorMessage.style.display = 'block';
        setTimeout(function() {
            errorMessage.style.display = 'none';
        }, 3000);
    }
}

function handleClick(event) {
    var elementCible = event.target;
    deleteTask(elementCible);
    event.stopPropagation(); 
}

function corbeille() {
    let tasklist = document.querySelector('.tasklist');
    tasklist.addEventListener('click', handleClick);
}

corbeille();

const newTaskButton = document.querySelector('.create-task-container button');
const modal = document.querySelector('.modal-dialog');

newTaskButton.addEventListener('click', function(event) {
    modal.style.display = 'block';
    event.stopPropagation();
});

document.addEventListener('click', function(event) {
    if (event.target === modal) {
        modal.style.display = 'none';
    }
});

const addButton = document.querySelector('.modal-dialog button');
const taskTitleInput = document.getElementById('task-title');

addButton.addEventListener('click', async function(event) {
    event.preventDefault(); // Empêche le formulaire de se soumettre

    const title = taskTitleInput.value;

    try {
        const response = await fetch('http://localhost:8000/api/task', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ title: title })
        });

        if (response.ok) {
            const newTask = await response.json();
            insertTaskInDom(newTask);
            const successMessage = document.querySelector('.message.success');
            successMessage.style.display = 'block';
            setTimeout(function() {
                successMessage.style.display = 'none';
            }, 3000);
        } else {
            throw new Error('Erreur lors de l\'ajout de la tâche');
        }
    } catch (error) {
        console.error('Une erreur est survenue lors de l\'ajout de la tâche:', error);
        const errorMessage = document.querySelector('.message.danger');
        errorMessage.style.display = 'block';
        setTimeout(function() {
            errorMessage.style.display = 'none';
        }, 3000);
    }

    taskTitleInput.value = '';
    modal.style.display = 'none';
});


// Attend que le document soit complètement chargé avant d'exécuter le code
document.addEventListener('DOMContentLoaded', function() {
    // Appelle la fonction task() pour afficher les tâches depuis l'API
    task();
});

// Fonction asynchrone pour mettre à jour une tâche
async function updateTask(taskId, newTitle) {
    try {
        const response = await fetch(`http://localhost:8000/api/task/${taskId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ title: newTitle })
        });

        if (response.ok) {
            // Mettez à jour l'élément DOM avec le nouveau titre
            const taskElement = document.querySelector(`li[data-id="${taskId}"] p`);
            taskElement.textContent = `ID: ${taskId} - ${newTitle}`;
            
            const successMessage = document.querySelector('.message.success');
            successMessage.style.display = 'block';
            setTimeout(function() {
                successMessage.style.display = 'none';
            }, 3000);
        } else {
            throw new Error('Erreur lors de la mise à jour de la tâche');
        }
    } catch (error) {
        console.error('Une erreur est survenue lors de la mise à jour de la tâche:', error);
        const errorMessage = document.querySelector('.message.danger');
        errorMessage.style.display = 'block';
        setTimeout(function() {
            errorMessage.style.display = 'none';
        }, 3000);
    }
}


// Ajoutez un gestionnaire d'événements pour la modification de tâche
function handleEditTask(event) {
    const elementCible = event.target;
    // Vérifie si l'élément cliqué a la classe 'edit' (l'icône de modification)
    if (elementCible.classList.contains('edit')) {
        // Récupère l'ID de la tâche à partir de l'attribut 'data-id' de l'élément parent
        const taskId = elementCible.parentNode.getAttribute('data-id');
        // Récupère le titre de la tâche depuis l'élément de paragraphe (p) correspondant
        const taskTitle = document.querySelector(`li[data-id="${taskId}"] p`).textContent;
        // Pré-remplit le champ d'entrée de la modal avec le titre de la tâche
        taskTitleInput.value = taskTitle.split(' - ')[1].trim();
        // Affiche la modal
        modal.style.display = 'block';
        // Ajoute un attribut 'data-task-id' à la modal pour stocker l'ID de la tâche en cours de modification
        modal.setAttribute('data-task-id', taskId);
        // Empêche la propagation de l'événement pour éviter les conflits avec d'autres gestionnaires d'événements
        event.stopPropagation();
    }
}
// Modifiez votre fonction corbeille() pour inclure le gestionnaire d'événements pour la modification de tâche
function corbeille() {
    let tasklist = document.querySelector('.tasklist');
    tasklist.addEventListener('click', handleClick);
    tasklist.addEventListener('click', handleEditTask); // Ajoutez le gestionnaire d'événements pour la modification de tâche
}

corbeille();

addButton.addEventListener('click', async function(event) {
    event.preventDefault(); // Empêche le formulaire de se soumettre

    const title = taskTitleInput.value;
    const taskId = modal.getAttribute('data-task-id');

    try {
        if (taskId) {
            // Si taskId existe, cela signifie que l'utilisateur est en train de modifier une tâche existante
            await updateTask(taskId, title);
        } else {
            // Sinon, l'utilisateur est en train d'ajouter une nouvelle tâche
            const response = await fetch('http://localhost:8000/api/task', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ title: title })
            });

            if (response.ok) {
                const newTask = await response.json();
                insertTaskInDom(newTask);
            } else {
                throw new Error('Erreur lors de l\'ajout de la tâche');
            }
        }

        const successMessage = document.querySelector('.message.success');
        successMessage.style.display = 'block';
        setTimeout(function() {
            successMessage.style.display = 'none';
        }, 3000);
    } catch (error) {
        console.error('Une erreur est survenue:', error);
        const errorMessage = document.querySelector('.message.danger');
        errorMessage.style.display = 'block';
        setTimeout(function() {
            errorMessage.style.display = 'none';
        }, 3000);
    }

    taskTitleInput.value = '';
    modal.style.display = 'none';
});





