<%@page import="entities.Ville"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Ville Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
    <!-- DataTables JS -->
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding-top: 5em;
        }

        .sidebar {
            height: 100vh;
            width: 250px;
            background-color: #E0E0E0;
            position: fixed;
            top: 0;
            left: 0;
            overflow-x: hidden;
            padding-top: 20px;
        }
        /* Ajoutez vos autres styles ici */
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-lg-3">
                <div class="sidebar">
                    <!-- Sidebar content -->
                    <img src="assets/admin.png" alt="Admin" class="admin">
                    <p><a href="VilleController">Gestion des villes</a></p>
                </div>
            </div>
            <div class="col-lg-9">
                <!-- Content -->
                <%-- Votre formulaire pour ajouter une ville --%>
                <form action="VilleController" method="post" onsubmit="return validateForm()">
                    <h1>Ajouter une Ville</h1>
                    <input type="hidden" id="selectedVilleId" name="selectedVilleId" value="" />
                    <br>
                    <span style="font-weight: bold;">Nom : </span><input type="text" name="ville" id="villeInput" required />
                    <br>
                    <br>
                    <button type="submit" class="btn btn-primary">Ajouter</button>
                </form>
                <h1>Liste des villes :</h1>
                <%-- Votre tableau pour afficher les villes existantes --%>
                <table id="villeTable" class="table">
                    <thead>
                        <tr>
                            <th>Nº</th>
                            <th>Nom</th>
                            <th>Supprimer</th>
                            <th>Modifier</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Utilisation de JSTL pour parcourir et afficher les villes existantes --%>
                        <c:forEach items="${villes}" var="v">
                            <tr>
                                <td>${v.id}</td>
                                <td>${v.nom}</td>
                                <td>
                                    <button class="btn btn-danger" onclick="deleteVille(${v.id})">Supprimer</button>
                                </td>
                                <td>
                                    <button class="btn btn-success" onclick="modifyVille(${v.id})">Modifier</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            $('#villeTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    'copy', 'excel', 'csv', 'pdf'
                ]
            });
        });

        function deleteVille(villeId) {
            if (confirm('Etes-vous sûr de vouloir supprimer cette ville ?')) {
                $.ajax({
                    type: 'POST',
                    url: 'VilleController?action=delete&villeId=' + villeId,
                    success: function (data) {
                            var table = $('#villeTable').DataTable();
                            var row = table.row($('#villeTable').find('tr:has(td:contains(' + villeId + '))'));
                            row.remove().draw();
                    },
                    error: function (xhr, status, error) {
                        console.error('Error deleting city:', error);
                        console.error('Status:', status);
                    }
                });
            }
        }

        function modifyVille(villeId) {
            var table = $('#villeTable').DataTable();
            var row = table.row($('#villeTable').find('tr:has(td:contains(' + villeId + '))'));
            var villeNom = row.data()[1];

            $('#selectedVilleId').val(villeId);
            $('input[name="ville"]').val(villeNom);

            $('button[type="submit"]').text('Modifier').removeClass('btn-primary').addClass('btn-success');

            $('h1').text('Modifier une Ville');
        }

        function validateForm() {
            var villeInput = document.getElementById('villeInput').value;
            if (villeInput.trim() === '') {
                alert('Veuillez remplir le champ Nom.');
                return false; // Empêche la soumission du formulaire si le champ est vide
            }
            return true; // Soumet le formulaire si le champ est rempli
        }
    </script>

    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
