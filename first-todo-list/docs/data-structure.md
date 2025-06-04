# Dictionnaire de données

## Task (`tasks`)

|Champ|Type|Spécificités|Description|
|-|-|-|-|
|id|INT|PRIMARY KEY, NOT NULL, UNSIGNED, AUTO_INCREMENT|L'identifiant de la tâche|
|title|VARCHAR(255)|NOT NULL|L'intitulé de la tâche|
|status|TINYINT(4)|NOT NULL, DEFAULT 0|le status de la tâche|
|created_at|TIMESTAMP|NOT NULL, DEFAULT CURRENT_TIMESTAMP|La date de création de la tâche|
|updated_at|TIMESTAMP|NULL|La date de la dernière mise à jour de la tâche|
|category|entity|NULL|La catégorie (autre entité) de la tâche|
|tag|entity|NULL|Un ou plusieurs tags rattachés à la tâche|

## Category (`categories`)

|Champ|Type|Spécificités|Description|
|-|-|-|-|
|id|INT|PRIMARY KEY, NOT NULL, UNSIGNED, AUTO_INCREMENT|L'identifiant de la catégorie|
|name|VARCHAR(50)|NOT NULL|Le nom de la catégorie|
|created_at|TIMESTAMP|NOT NULL, DEFAULT CURRENT_TIMESTAMP|La date de création de la catégorie|
|updated_at|TIMESTAMP|NULL|La date de la dernière mise à jour de la catégorie|

## Tag (`tags`)

|Champ|Type|Spécificités|Description|
|-|-|-|-|
|id|INT|PRIMARY KEY, NOT NULL, UNSIGNED, AUTO_INCREMENT|L'identifiant du tag|
|label|VARCHAR(50)|NOT NULL|nom du tag|
|created_at|TIMESTAMP|NOT NULL, DEFAULT CURRENT_TIMESTAMP|La date de création du tag|
|updated_at|TIMESTAMP|NULL|La date de la dernière mise à jour du tag|
