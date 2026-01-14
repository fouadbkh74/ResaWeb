
<header id="header" class="header d-flex align-items-center fixed-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center justify-content-between">

      <a href="index.html" class="logo d-flex align-items-center">
        <!-- Uncomment the line below if you also wish to use an image logo -->
        <!-- <img src="assets/img/logo.webp" alt=""> -->
        <i class="bi bi-buildings"></i>
        <h1 class="sitename">Les Jardins Solidaires</h1>
      </a>

      <nav id="navmenu" class="navmenu">
        <ul>
          <li><a href="<?php echo base_url()?>index.php/" class="active">Acceuil</a></li>
          <li ><a href="<?php echo base_url()?>"><span>Members</span> <i></i></a>
          <li><a href="<?php echo base_url() ?>index.php/actualite/afficher">Actualités</a></li>
          <li class="dropdown"><a href="<?php echo base_url()?>"><span>Contact</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>

             <ul>  
              <li ><a href="<?php echo base_url()?>index.php/message/envoyer">Envoyer Une Demande</a></li>
              <li><a href="<?php echo base_url() ?>index.php/message/verifier">Suivi ma demande</a></li>
             </ul>  
            </li>  
                       
          <li><a href="<?php echo base_url() ?>index.php/actualite/afficher">Se Connecter</a></li>

        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>

    </div>
  </header>