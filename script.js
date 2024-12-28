// JavaScript for image slideshow and hover effects

let slideIndex = 0;
const slides = document.getElementsByClassName("mySlides");

function showSlides() {
    // Hide all slides
    for (let i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }
    // Increment the index and loop back if necessary
    slideIndex++;
    if (slideIndex > slides.length) {
        slideIndex = 1;
    }
    // Show the current slide
    slides[slideIndex - 1].style.display = "block";
    // Change slide every 3 seconds
    setTimeout(showSlides, 3000);
}

showSlides(); // Start the slideshow

// Hover effect for login form sliding
const loginBox = document.querySelector(".login-box-wrapper");
const slideshowImages = document.querySelectorAll(".slideshow-image");

slideshowImages.forEach(image => {
    image.addEventListener('mouseenter', () => {
        // Slide down the login form
        loginBox.style.transform = 'translateY(20px)';
    });

    image.addEventListener('mouseleave', () => {
        // Slide back up
        loginBox.style.transform = 'translateY(0)';
    });
});

// Optionally, you can add a smooth scroll effect for anchors (like when clicking "About", "Menu", etc.)
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});
async function fetchData() {
    try {
        const response = await fetch('your-api-endpoint', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        const result = await response.json();
        document.getElementById('result').innerHTML = result;
    } catch (error) {
        console.error('Error:', error);
    }
}