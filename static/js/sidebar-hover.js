document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.image-button img').forEach(img => {
        const original = img.src;
        const hover = img.getAttribute('data-hover');

        img.addEventListener('mouseover', () => img.src = hover);
        img.addEventListener('mouseout', () => img.src = original);
    });
});
