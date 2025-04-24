// Fonction asynchrone qui récupère et affiche les tâches depuis l'API
async function task() {
  try {
    // Effectue une requête HTTP GET pour récupérer les tâches
    const response = await fetch("http://localhost:8000/api/task");

    // Vérifie si la réponse n'est pas correcte (statut HTTP différent de 2xx)
    if (!response.ok) {
      throw new Error("Erreur lors de la récupération des données");
    }

    // Convertit la réponse en JSON (un tableau de tâches)
    const data = await response.json();

    // Boucle sur chaque tâche reçue pour les insérer dans le DOM
    for (const task of data) {
      insertTaskInDom(task); // Appelle la fonction qui gère l'insertion dans le DOM
    }
  } catch (error) {
    // En cas d'erreur (réseau ou serveur), log l'erreur dans la console
    console.error("Une erreur est survenue:", error);
  }
}

// Fonction asynchrone qui insère une tâche dans le DOM
async function insertTaskInDom(task) {
  // Crée un élément de liste <li> pour chaque tâche
  const liElement = document.createElement("li");
  liElement.setAttribute("data-id", task.id); // Ajoute un attribut 'data-id' avec l'ID de la tâche

  // Crée un élément de paragraphe <p> pour afficher l'ID et le titre de la tâche
  const pElement = document.createElement("p");
  pElement.textContent = ` ${task.id} - ${task.title}`; // Définit le contenu du paragraphe

  // Crée un div pour l'icône de suppression
  const divDeleteElement = document.createElement("div");
  divDeleteElement.classList.add("delete"); // Ajoute la classe 'delete' pour styliser l'élément
  divDeleteElement.setAttribute("data-id", task.id); // Associe l'ID de la tâche à l'élément

  // Crée un div pour l'icône de modification
  const divEditElement = document.createElement("div");
  divEditElement.classList.add("edit"); // Ajoute la classe 'edit' pour styliser l'élément

  // Ajoute les éléments <p>, <div> (delete et edit) à l'élément <li>
  liElement.append(pElement);
  liElement.append(divDeleteElement);
  liElement.append(divEditElement);

  // Insère l'élément <li> dans la liste des tâches dans le DOM
  document.querySelector(".tasklist").append(liElement);
}

// Fonction asynchrone qui supprime une tâche via l'API
async function deleteTask(elementList) {
  try {
    // Récupère l'ID de la tâche à partir de l'attribut 'data-id'
    let id = elementList.getAttribute("data-id");

    // Envoie une requête DELETE à l'API pour supprimer la tâche
    await fetch(`http://localhost:8000/api/tasks/${id}`, { method: "DELETE" });

    // Supprime l'élément correspondant à la tâche du DOM
    elementList.parentNode.remove();

    // Affiche un message de succès temporairement
    const successMessage = document.querySelector(".message.success");
    successMessage.style.display = "block";
    setTimeout(function () {
      successMessage.style.display = "none";
    }, 3000);
  } catch (error) {
    // Affiche un message d'erreur en cas de problème
    console.error("Erreur lors de la suppression de la tâche:", error);
    const errorMessage = document.querySelector(".message.danger");
    errorMessage.style.display = "block";
    setTimeout(function () {
      errorMessage.style.display = "none";
    }, 3000);
  }
}

// Fonction qui gère le clic pour supprimer une tâche
function handleClick(event) {
  var elementCible = event.target; // L'élément cliqué
  deleteTask(elementCible); // Supprime la tâche associée
  event.stopPropagation(); // Empêche la propagation de l'événement vers d'autres éléments
}

// Fonction qui attache des événements à la liste de tâches
function corbeille() {
  let tasklist = document.querySelector(".tasklist"); // Sélectionne la liste des tâches
  tasklist.addEventListener("click", handleClick); // Ajoute un gestionnaire d'événements pour la suppression
}

corbeille(); // Appelle la fonction pour initialiser les événements

// Sélectionne le bouton pour créer une nouvelle tâche et la modal correspondante
const newTaskButton = document.querySelector(".create-task-container button");
const modal = document.querySelector(".modal-dialog");

// Affiche la modal de création de tâche lorsqu'on clique sur le bouton "nouvelle tâche"
newTaskButton.addEventListener("click", function (event) {
  modal.style.display = "block"; // Affiche la modal
  event.stopPropagation(); // Empêche la propagation de l'événement
});

// Cache la modal si l'utilisateur clique en dehors d'elle
document.addEventListener("click", function (event) {
  if (event.target === modal) {
    modal.style.display = "none"; // Cache la modal
  }
});

// Sélectionne le bouton pour ajouter ou modifier une tâche et le champ de saisie du titre
const addButton = document.querySelector(".modal-dialog button");
const taskTitleInput = document.getElementById("task-title");

// Gère l'ajout ou la modification de tâche
addButton.addEventListener("click", async function (event) {
  event.preventDefault(); // Empêche le rechargement de la page

  const title = taskTitleInput.value; // Récupère le titre de la tâche

  try {
    const response = await fetch("http://localhost:8000/api/task", {
      method: "POST", // Méthode POST pour ajouter une nouvelle tâche
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ title: title }), // Envoie le titre en JSON
    });

    if (response.ok) {
      const newTask = await response.json(); // Récupère la nouvelle tâche ajoutée
      insertTaskInDom(newTask); // L'insère dans le DOM
    } else {
      throw new Error("Erreur lors de l'ajout de la tâche");
    }
  } catch (error) {
    console.error(
      "Une erreur est survenue lors de l'ajout de la tâche:",
      error
    );
    const errorMessage = document.querySelector(".message.danger");
    errorMessage.style.display = "block";
    setTimeout(function () {
      errorMessage.style.display = "none";
    }, 3000);
  }

  taskTitleInput.value = ""; // Vide le champ de saisie
  modal.style.display = "none"; // Cache la modal
});

// Exécute le code après que le DOM soit chargé
document.addEventListener("DOMContentLoaded", function () {
  task(); // Appelle la fonction pour charger et afficher les tâches depuis l'API
});

// Fonction asynchrone pour mettre à jour une tâche
async function updateTask(taskId, newTitle) {
  try {
    const response = await fetch(`http://localhost:8000/api/task/${taskId}`, {
      method: "PUT", // Méthode PUT pour la mise à jour
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ title: newTitle }), // Envoie le nouveau titre
    });

    if (response.ok) {
      // Met à jour le texte de la tâche dans le DOM
      const taskElement = document.querySelector(`li[data-id="${taskId}"] p`);
      taskElement.textContent = `ID: ${taskId} - ${newTitle}`;

      const successMessage = document.querySelector(".message.success");
      successMessage.style.display = "block";
      setTimeout(function () {
        successMessage.style.display = "none";
      }, 3000);
    } else {
      throw new Error("Erreur lors de la mise à jour de la tâche");
    }
  } catch (error) {
    console.error(
      "Une erreur est survenue lors de la mise à jour de la tâche:",
      error
    );
    const errorMessage = document.querySelector(".message.danger");
    errorMessage.style.display = "block";
    setTimeout(function () {
      errorMessage.style.display = "none";
    }, 3000);
  }
}

// Gère l'événement de modification de tâche
function handleEditTask(event) {
  const elementCible = event.target;

  if (elementCible.classList.contains("edit")) {
    const taskId = elementCible.parentNode.getAttribute("data-id"); // Récupère l'ID de la tâche
    const taskTitle = document.querySelector(
      `li[data-id="${taskId}"] p`
    ).textContent;
    taskTitleInput.value = taskTitle.split(" - ")[1].trim(); // Remplit le champ avec le titre actuel
    modal.style.display = "block"; // Affiche la modal
    modal.setAttribute("data-task-id", taskId); // Stocke l'ID de la tâche en cours
    event.stopPropagation(); // Empêche la propagation de l'événement
  }
}

// Met à jour la fonction corbeille pour inclure la gestion de modification de tâche
function corbeille() {
  let tasklist = document.querySelector(".tasklist");
  tasklist.addEventListener("click", handleClick); // Pour supprimer
  tasklist.addEventListener("click", handleEditTask); // Pour modifier
}

corbeille(); // Réinitialise l'écouteur d'événements

// Gère l'ajout ou la modification lors du clic sur le bouton d'ajout
addButton.addEventListener("click", async function (event) {
  event.preventDefault(); // Empêche le rechargement de la page

  const title = taskTitleInput.value; // Récupère le titre de la tâche
  const taskId = modal.getAttribute("data-task-id"); // Récupère l'ID de la tâche en cours de modification (si elle existe)

  try {
    let response;
    if (taskId) {
      // Mise à jour de la tâche existante
      response = await updateTask(taskId, title); // La fonction updateTask gère déjà la requête PUT
    } else {
      // Ajout d'une nouvelle tâche
      response = await fetch("http://localhost:8000/api/task", {
        method: "POST", // Utilise la méthode POST pour créer une tâche
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ title: title }), // Envoie le titre en tant que payload JSON
      });
    }

    // Affiche le statut HTTP de la réponse pour voir ce que l'API renvoie
    console.log("Statut de la réponse:", response.status);

    // Vérifie si la réponse est correcte (statut 2xx)
    if (response.ok) {
      // Si c'est une nouvelle tâche, récupère-la et insère-la dans le DOM
      if (!taskId) {
        const newTask = await response.json();
        insertTaskInDom(newTask); // Insère la nouvelle tâche dans le DOM
      }

      // Affiche le message de succès
      const successMessage = document.querySelector(".message.success");
      successMessage.style.display = "block";
      setTimeout(function () {
        successMessage.style.display = "none";
      }, 3000);
    } else {
      // Si le statut n'est pas 2xx, lance une erreur
      throw new Error(
        "Erreur lors de l'ajout ou de la mise à jour de la tâche"
      );
    }
  } catch (error) {
    // Enregistre l'erreur pour avoir plus d'informations
    console.error("Erreur détectée:", error);

    // Affiche un message d'erreur dans le DOM
    const errorMessage = document.querySelector(".message.danger");
    errorMessage.style.display = "block";
    setTimeout(function () {
      errorMessage.style.display = "none";
    }, 3000);
  }

  // Vide le champ de titre et cache la modal
  taskTitleInput.value = "";
  modal.style.display = "none";
});
