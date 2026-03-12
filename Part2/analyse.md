# Analyse du code blockchain.py

## Question: Quel est le rôle de la méthode append_block() ? Comment ajoute-t-elle un nouveau bloc à la chaîne.

La méthode `append_block()` a pour rôle de créer un nouveau bloc et de l'ajouter à la blockchain.
Voici comment elle procède :
1.  Elle prend en paramètres le `nonce` (trouvé par la preuve de travail) et le `hash_of_previous_block` (le hachage du bloc précédent dans la chaîne).
2.  Elle construit un dictionnaire représentant le nouveau bloc, qui contient :
    *   `index`: La position du bloc dans la chaîne (la longueur actuelle de la chaîne).
    *   `timestamp`: L'heure de création du bloc.
    *   `transactions`: La liste des transactions courantes qui seront incluses dans ce bloc.
    *   `nonce`: Le nonce validé par la preuve de travail.
    *   `hash_of_previous_block`: Le hachage du bloc précédent, assurant le lien entre les blocs.
3.  Après avoir inclus les transactions courantes dans le bloc, elle réinitialise la liste `current_transactions` pour le bloc suivant.
4.  Enfin, elle ajoute le nouveau bloc à la fin de la liste `self.chain`, qui représente la blockchain.

---

## Questions :
1. Décrivez le processus par lequel la méthode proof_of_work() trouve le nonce correct. Quelle est l'importance du paramètre difficulty_target dans ce processus ?

La méthode `proof_of_work()` implémente l'algorithme de preuve de travail pour trouver un `nonce` qui satisfait une condition de difficulté définie.

1.  La méthode commence avec un `nonce` initialisé à 0.
2.  Elle entre dans une boucle qui continue tant que le `nonce` actuel n'est pas valide.
3.  À l'intérieur de la boucle, elle appelle la méthode `valid_proof()` en lui passant l'index du bloc, le hachage du bloc précédent, les transactions et le `nonce` actuel.
4.  La méthode `valid_proof()` concatène ces informations, les encode, puis calcule le hachage SHA-256 du résultat.
5.  Elle vérifie si ce hachage commence par la chaîne de caractères définie dans `difficulty_target` (par exemple, "0000").
6.  Si le hachage est valide (`valid_proof()` retourne `True`), la boucle `proof_of_work()` se termine et le `nonce` est retourné.
7.  Sinon (`valid_proof()` retourne `False`), le `nonce` est incrémenté de 1 et le processus recommence.

2. Modifiez le paramètre difficulty_target en (difficulté réduite) et observez comment cela affecte le processus de minage. Quels changements se produisent et pourquoi ?

Le `difficulty_target` est une chaîne de caractères (par exemple, `"0000"`) qui définit la condition que le hachage d'un bloc valide doit remplir. L'importance de ce paramètre est capitale :
    *   Plus la chaîne `difficulty_target` est longue et complexe (par exemple, plus elle contient de zéros au début), plus il est difficile et long de trouver un `nonce` valide.
    *   En ajustant la difficulté, on peut contrôler le temps moyen nécessaire pour miner un nouveau bloc.
    *   Une difficulté élevée rend extrêmement coûteux en termes de calcul le fait de modifier un bloc passé.

En modifiant `difficulty_target` de `"0000"` à une valeur plus simple comme `"00"`, on **réduit la difficulté du minage**.
La condition à satisfaire devient beaucoup moins stricte. Avec `"00"`, la probabilité de trouver un hachage valide est de 1 sur 256, alors qu'avec `"0000"` elle est de 1 sur 65 536. Il est donc statistiquement 256 fois plus facile et plus rapide de trouver un `nonce` valide.

---

## Question: Expliquez comment fonctionne la méthode add_transaction(). Quelles informations sont nécessaires pour une transaction ?

La méthode `add_transaction()` est responsable de l'ajout d'une nouvelle transaction à la liste des transactions en attente, qui seront ensuite incluses dans le prochain bloc miné.

Fonctionnement :
1.  La méthode reçoit les informations de la transaction en tant que paramètres.
2.  Elle crée un dictionnaire pour représenter la transaction.
3.  Ce dictionnaire est ensuite ajouté à la liste `self.current_transactions`.
4.  Enfin, la méthode retourne l'index du prochain bloc qui sera miné.

Informations nécessaires pour une transaction :
1.  `sender`: L'adresse de l'expéditeur.
2.  `recipient`: L'adresse du destinataire.
3.  `amount`: Le montant de la transaction.

---

## Questions :
1. Décrivez comment la méthode valid_chain() garantit l'intégrité de la blockchain. Quelles vérifications sont effectuées pour valider les blocs et leur contenu ?

La méthode parcourt la chaîne bloc par bloc et effectue deux vérifications essentielles :
1.  **Vérification de la liaison de hachage :** Elle vérifie que le champ `hash_of_previous_block` du bloc actuel correspond bien au hachage réel du bloc précédent.
2.  **Vérification de la preuve de travail :** Elle vérifie que le `nonce` du bloc est correct en appelant `valid_proof()`.

Un bloc est validé en vérifiant le hash

2. Que se passerait-il si un attaquant tentait de modifier les données au milieu de la chaîne ? Comment la méthode valid_chain() empêche-t-elle ce type d'attaque ?

Si un attaquant modifie les données d'un bloc, le hachage de ce bloc change. Par conséquent, le lien de hachage avec le bloc suivant est rompu.
La méthode `valid_chain()` détectera cette incohérence lors de la vérification de la liaison de hachage et déclarera la chaîne invalide.
Pour que l'attaque réussisse, l'attaquant devrait recalculer la preuve de travail pour le bloc modifié **et pour tous les blocs suivants**, ce qui est une tâche extrêmement coûteuse en calcul et donc irréalisable sur une chaîne suffisamment longue. C'est ainsi que la méthode protège la chaîne.

---

## Question : Expliquer le rôle de la méthode update_blockchain().

La méthode `update_blockchain()` implémente un algorithme de consensus pour synchroniser la chaîne de blocs d'un nœud avec le reste du réseau. Son rôle est de s'assurer que le nœud travaille toujours sur la version la plus longue et donc la plus fiable de la blockchain.

Fonctionnement :
1.  Elle parcourt la liste des nœuds voisins pour les interroger.
2.  Pour chaque voisin, elle récupère sa chaîne. Si cette chaîne est plus longue que la sienne, elle la vérifie avec `valid_chain()`.
3.  Si une chaîne valide et plus longue est trouvée, le nœud remplace sa propre chaîne par cette nouvelle chaîne.

Avec `update_blockchain()` les nœuds se mettent d'accord sur une version unique et cohérente de l'historique des transactions en adoptant la chaîne valide la plus longue.
