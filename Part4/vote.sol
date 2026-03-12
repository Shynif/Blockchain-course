// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SystemeDeVote {
    
    // Structure pour définir un candidat
    struct Candidat {
        uint id;
        string nom;
        uint nombreDeVotes;
    }

    // On stocke les adresses (comptes) de ceux qui ont déjà voté pour éviter la triche
    mapping(address => bool) public aVote;
    
    // On stocke la liste des candidats
    mapping(uint => Candidat) public candidats;
    
    // Compteur pour le nombre total de candidats
    uint public nombreDeCandidats;

    // Le constructeur est exécuté une seule fois lors du déploiement
    constructor() {
        ajouterCandidat("Alice");
        ajouterCandidat("Bob");
    }

    // Fonction privée pour ajouter un candidat
    function ajouterCandidat(string memory _nom) private {
        nombreDeCandidats++;
        candidats[nombreDeCandidats] = Candidat(nombreDeCandidats, _nom, 0);
    }

    // Fonction publique pour voter
    function voter(uint _candidatId) public {
        // 1. Vérifier que la personne n'a pas déjà voté
        require(!aVote[msg.sender], "Vous avez deja vote.");
        
        // 2. Vérifier que l'ID du candidat est valide
        require(_candidatId > 0 && _candidatId <= nombreDeCandidats, "Candidat invalide.");

        // 3. Enregistrer que cette personne a voté
        aVote[msg.sender] = true;

        // 4. Ajouter 1 vote au candidat choisi
        candidats[_candidatId].nombreDeVotes++;
    }
}
