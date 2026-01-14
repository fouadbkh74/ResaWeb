# Instructions pour corriger le problème CSS - Étape par étape

## 🔍 Problème identifié
Le dossier s'appelle **`bootstarp`** (avec une faute d'orthographe) mais le code PHP cherche **`bootstrap`**. C'est pourquoi les fichiers CSS ne se chargent pas.

## ✅ Solution : Renommer le dossier

### Méthode 1 : Via l'Explorateur de fichiers Windows

1. **Ouvrez l'Explorateur de fichiers Windows**
   - Appuyez sur `Windows + E`

2. **Naviguez vers le dossier public**
   - Allez dans : `home/2025DIFAL3/e22509077/public_html/V1/ci/public`
   - OU utilisez le chemin complet si vous savez où se trouve votre projet

3. **Trouvez le dossier `bootstarp`**
   - Vous devriez voir un dossier nommé **`bootstarp`** (avec la faute)

4. **Renommez le dossier**
   - Cliquez droit sur le dossier **`bootstarp`**
   - Sélectionnez **"Renommer"** (ou appuyez sur `F2`)
   - Changez le nom en : **`bootstrap`** (avec le "o" correct)
   - Appuyez sur `Entrée` pour confirmer

5. **Vérifiez**
   - Le dossier devrait maintenant s'appeler **`bootstrap`**
   - À l'intérieur, vous devriez voir le dossier **`NiceSchool`**

### Méthode 2 : Via PowerShell (si vous préférez la ligne de commande)

1. **Ouvrez PowerShell**
   - Appuyez sur `Windows + X` et sélectionnez "Windows PowerShell"
   - OU tapez "PowerShell" dans le menu Démarrer

2. **Naviguez vers le bon dossier**
   ```powershell
   cd "VOTRE_CHEMIN_COMPLET/home/2025DIFAL3/e22509077/public_html/V1/ci/public"
   ```
   *(Remplacez VOTRE_CHEMIN_COMPLET par le chemin complet jusqu'à home)*

3. **Listez les dossiers pour vérifier**
   ```powershell
   dir
   ```
   Vous devriez voir le dossier `bootstarp`

4. **Renommez le dossier**
   ```powershell
   Rename-Item -Path "bootstarp" -NewName "bootstrap"
   ```

5. **Vérifiez que ça a fonctionné**
   ```powershell
   dir
   ```
   Vous devriez maintenant voir `bootstrap` au lieu de `bootstarp`

### Méthode 3 : Via l'interface FTP/cPanel (si vous êtes sur un serveur distant)

1. **Connectez-vous à votre cPanel ou client FTP**
2. **Naviguez vers** : `public_html/V1/ci/public`
3. **Trouvez le dossier `bootstarp`**
4. **Renommez-le en `bootstrap`**
   - Dans cPanel : Clic droit → Rename
   - Dans un client FTP : Clic droit → Rename

## 🔄 Après le renommage

1. **Rafraîchissez votre page web**
   - Appuyez sur `Ctrl + F5` (ou `Cmd + Shift + R` sur Mac) pour forcer le rechargement
   - Les fichiers CSS devraient maintenant se charger correctement

2. **Vérifiez dans les outils de développement**
   - Appuyez sur `F12` pour ouvrir les outils de développement
   - Allez dans l'onglet **"Network"** (Réseau)
   - Rechargez la page
   - Vérifiez que les fichiers CSS se chargent avec un statut **200 OK**

## ❓ Si ça ne fonctionne pas

1. **Vérifiez que le dossier contient bien `NiceSchool`**
   - Le chemin devrait être : `public/bootstrap/NiceSchool/assets/css/main.css`

2. **Vérifiez les permissions**
   - Le dossier doit avoir les permissions de lecture

3. **Vérifiez l'URL de base**
   - Assurez-vous que `base_url()` dans CodeIgniter est correctement configuré
   - Le fichier se trouve généralement dans : `app/Config/App.php`

## 📝 Note importante

**Ne touchez PAS au code PHP** - le problème vient uniquement du nom du dossier. Une fois renommé, tout devrait fonctionner automatiquement !


