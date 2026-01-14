<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Membre - Les Jardins Solidaires</title>

    <!-- Custom fonts for this template-->
    <link href="<?php echo base_url();?>bootstrap2/bootstrap2/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="<?php echo base_url();?>bootstrap2/bootstrap2/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="<?php echo base_url();?>bootstrap2/bootstrap2/css/modern.css" rel="stylesheet">

</head>

<body id="page-top">

    <!-- Page Wrapper (SANS SIDEBAR) -->
    <div id="wrapper">

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 0 !important;">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                    <!-- Topbar - Logo et Titre -->
                    <a class="navbar-brand d-flex align-items-center" href="<?= base_url(); ?>index.php/utilisateur" style="margin-left: 1rem;">
                        <div class="sidebar-brand-icon" style="color: #0c330e;">
                            <i class="fas fa-seedling"></i>
                        </div>
                        <div class="sidebar-brand-text mx-3" style="color: #0c330e; font-weight: bold;">Les Jardins Solidaires</div>
                    </a>

                    <!-- Topbar Search -->
                    <form class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                        <div class="input-group">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="Rechercher..."
                                aria-label="Search" aria-describedby="basic-addon2">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Topbar Navbar -->
                    <ul class="navbar-nav ml-auto">

                        <!-- Nav Item - Mes Réservations -->
                        <li class="nav-item mx-1">
                            <a class="nav-link" href="<?= base_url(); ?>index.php/utilisateur/mes_reservations" role="button">
                                <i class="fas fa-calendar-alt fa-fw" style="color: #0c330e;"></i>
                                <span class="d-none d-lg-inline text-gray-600 small ml-1">Mes Réservations</span>
                            </a>
                        </li>

                        <!-- Nav Item - Liste Adhérents -->
                        <li class="nav-item mx-1">
                            <a class="nav-link" href="<?= base_url(); ?>index.php/utilisateur/liste_adherents" role="button">
                                <i class="fas fa-users fa-fw" style="color: #0c330e;"></i>
                                <span class="d-none d-lg-inline text-gray-600 small ml-1">Liste Adhérents</span>
                            </a>
                        </li>

                        <!-- Nav Item - Séances Réservées (SPRINT 2) -->
                        <li class="nav-item mx-1">
                            <a class="nav-link" href="<?= base_url(); ?>index.php/utilisateur/seances_reservees" role="button">
                                <i class="fas fa-calendar-check fa-fw" style="color: #0c330e;"></i>
                                <span class="d-none d-lg-inline text-gray-600 small ml-1">Séances Réservées</span>
                            </a>
                        </li>

                        <!-- Nav Item - Notifications -->
                        <li class="nav-item dropdown no-arrow mx-1">
                            <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-bell fa-fw"></i>
                                <!-- Counter - Notifications -->
                                <span class="badge badge-danger badge-counter">0</span>
                            </a>
                            <!-- Dropdown - Notifications -->
                            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="alertsDropdown">
                                <h6 class="dropdown-header">
                                    Notifications
                                </h6>
                                <a class="dropdown-item text-center small text-gray-500" href="#">Aucune notification</a>
                            </div>
                        </li>

                        <div class="topbar-divider d-none d-sm-block"></div>

                        <!-- Nav Item - User Information -->
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                                    <?php 
                                        if (isset($user)) {
                                            echo esc($user);
                                        } elseif (session()->has('user')) {
                                            echo esc(session()->get('user'));
                                        } else {
                                            echo 'Invité';
                                        }
                                    ?>
                                </span>
                                <img class="img-profile rounded-circle"
                                    src="<?php echo base_url();?>bootstrap2/bootstrap2/img/undraw_profile.svg">
                            </a>
                            <!-- Dropdown - User Information -->
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="<?php echo base_url();?>index.php/utilisateur/afficher_profil">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Mon Profil
                                </a>
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Paramètres
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Déconnexion
                                </a>
                            </div>
                        </li>

                    </ul>

                </nav>
                <!-- End of Topbar -->
