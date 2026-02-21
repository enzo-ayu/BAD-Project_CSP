document.addEventListener('DOMContentLoaded', () => {

    // Expand/collapse sidebar
    const resizeBtn = document.getElementById("resize-btn");
    resizeBtn.addEventListener("click", (e) => {
        e.preventDefault();
        document.body.classList.toggle("sb-expanded");
    });

    // Hover effect: hover anywhere on the link swaps the image
    document.querySelectorAll('#sidebar li a').forEach(link => {
        const img = link.querySelector('img');
        const originalSrc = img.src;
        const hoverSrc = img.getAttribute('data-hover');

        link.addEventListener('mouseenter', () => {
            img.src = hoverSrc;
        });

        link.addEventListener('mouseleave', () => {
            img.src = originalSrc;
        });
    });

});