<h2><?php echo $titre; ?></h2>
<?php
    if (! empty($logins) && is_array($logins))
    {
    foreach ($logins as $pseudos)
    {
    echo "<br />";
    echo " -- ";
    echo $pseudos["cpt_pseudo"];
    echo " -- ";
    echo "<br />";
    }
    echo " -- ";
    echo $nbr->nb;
    }
    else {
    echo("<h3>Aucun compte pour le moment</h3>");
    }
?>