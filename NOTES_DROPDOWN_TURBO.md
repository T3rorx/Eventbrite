# 🔧 Solution : Problème Dropdown Bootstrap + Turbo Drive

## 📋 **Problème identifié**

### **Symptômes :**
- Le dropdown "Mon profil" dans la navbar fonctionnait "un coup sur 2"
- Après navigation vers une autre page, le dropdown ne répondait plus
- Il fallait recharger la page pour que le dropdown redevienne fonctionnel

### **Cause racine :**
**Conflit entre Turbo Drive (Rails 7) et Bootstrap JavaScript**

- Turbo Drive intercepte les navigations et change le DOM sans recharger la page complète
- Les composants Bootstrap (dropdowns) perdent leur état et leurs event listeners
- Bootstrap JS n'est pas automatiquement réinitialisé après les navigations Turbo

## ✅ **Solution implémentée**

### **1. Désactivation Turbo sur les liens dropdown**
```erb
<!-- Dans app/views/layouts/application.html.erb -->
<a class="nav-link dropdown-toggle" href="#" role="button" 
   data-bs-toggle="dropdown" data-turbo="false" aria-expanded="false">
  Mon profil
</a>

<ul class="dropdown-menu dropdown-menu-end">
  <li><%= link_to "Mon profil", user_path(current_user), 
      class: "dropdown-item", data: { turbo: false } %></li>
  <li><%= link_to "Se déconnecter", destroy_user_session_path, 
      data: { turbo_method: :delete }, class: "dropdown-item" %></li>
</ul>
```

### **2. JavaScript de réinitialisation automatique**
```javascript
// Dans app/views/layouts/application.html.erb
<script>
  // Fix Bootstrap dropdowns with Turbo Drive
  document.addEventListener('turbo:load', function() {
    // Re-initialize all dropdowns
    var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
    var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
      return new bootstrap.Dropdown(dropdownToggleEl);
    });
    
    // Close dropdowns when clicking on links
    document.querySelectorAll('.dropdown-item').forEach(function(item) {
      item.addEventListener('click', function() {
        var dropdown = bootstrap.Dropdown.getInstance(item.closest('.dropdown').querySelector('.dropdown-toggle'));
        if (dropdown) {
          dropdown.hide();
        }
      });
    });
  });
  
  // Also fix on page refresh
  document.addEventListener('DOMContentLoaded', function() {
    var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
    var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
      return new bootstrap.Dropdown(dropdownToggleEl);
    });
    
    // Close dropdowns when clicking on links
    document.querySelectorAll('.dropdown-item').forEach(function(item) {
      item.addEventListener('click', function() {
        var dropdown = bootstrap.Dropdown.getInstance(item.closest('.dropdown').querySelector('.dropdown-toggle'));
        if (dropdown) {
          dropdown.hide();
        }
      });
    });
  });
</script>
```

### **3. Styles CSS pour le thème sombre**
```css
/* Dans app/assets/stylesheets/application.css */
.dropdown-menu {
  background-color: rgba(22, 43, 68, 0.95);
  border-color: rgba(79, 163, 209, 0.3);
  backdrop-filter: blur(10px);
}

.dropdown-item {
  color: var(--gr-ice);
}

.dropdown-item:hover {
  background-color: rgba(79, 163, 209, 0.2);
  color: var(--gr-highlight);
}

.dropdown-divider {
  border-color: rgba(79, 163, 209, 0.2);
}
```

## 🎯 **Comment ça fonctionne**

### **Événements Turbo :**
- `turbo:load` : Se déclenche à chaque navigation Turbo (changement de page)
- `DOMContentLoaded` : Se déclenche au chargement initial de la page

### **Processus de réparation :**
1. **Navigation Turbo** → `turbo:load` se déclenche
2. **Sélection** de tous les `.dropdown-toggle`
3. **Réinitialisation** des instances Bootstrap Dropdown
4. **Re-attachement** des event listeners pour fermer le dropdown
5. **Dropdown fonctionnel** immédiatement

## 📚 **Références techniques**

### **Turbo Drive Events :**
- [Turbo Drive Documentation](https://turbo.hotwired.dev/reference/events)
- `turbo:load` : Page chargée via Turbo Drive
- `DOMContentLoaded` : Page chargée normalement

### **Bootstrap 5 Dropdown API :**
- [Bootstrap Dropdown Documentation](https://getbootstrap.com/docs/5.3/components/dropdowns/)
- `bootstrap.Dropdown.getInstance()` : Récupère l'instance existante
- `new bootstrap.Dropdown()` : Crée une nouvelle instance

## 🚀 **Résultat**

✅ **Dropdown fonctionne à 100%** après chaque navigation  
✅ **Plus besoin de recharger** la page  
✅ **UX fluide** et professionnelle  
✅ **Compatible** avec le thème sombre Grenoble Roller  

## 🔄 **Application à d'autres composants**

Cette solution peut être étendue à d'autres composants Bootstrap qui ont des problèmes similaires :
- Modals
- Tooltips
- Popovers
- Carousels

**Pattern général :**
```javascript
document.addEventListener('turbo:load', function() {
  // Réinitialiser tous les composants Bootstrap problématiques
  // Re-attacher les event listeners
});
```

---
**Date :** Décembre 2024  
**Rails Version :** 7.x  
**Bootstrap Version :** 5.3.3  
**Turbo Version :** Inclus dans Rails 7
