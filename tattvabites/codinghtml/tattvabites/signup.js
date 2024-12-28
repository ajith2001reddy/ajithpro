document.querySelector(".signup-container form").addEventListener("submit", function(e) {
    e.preventDefault();

    // Get user input values
    const username = document.getElementById('username').value;
    const country = document.getElementById('country').value;
    const phone = document.getElementById('phone').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm-password').value;

    // Validate passwords match
    if (password !== confirmPassword) {
        alert("Passwords do not match!");
        return;
    }

    // Check if the username already exists in localStorage
    let users = JSON.parse(localStorage.getItem("users")) || [];
    const userExists = users.some(user => user.username === username);
    if (userExists) {
        alert("Username already taken!");
        return;
    }

    // Store user data in localStorage
    const newUser = {
        username: username,
        country: country,
        phone: phone,
        password: password
    };

    users.push(newUser);
    localStorage.setItem("users", JSON.stringify(users));

    alert("Account created successfully!");
    window.location.href = "login.html";  // Redirect to login page
});
