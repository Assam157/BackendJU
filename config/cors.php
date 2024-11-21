 <?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    // Define the paths where CORS should be applied (e.g., your API paths)
    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    // Specify which methods are allowed. '*' allows all HTTP methods.
    'allowed_methods' => ['*'],

    // Define allowed origins (domains). Replace with specific URLs or use a dynamic approach.
    'allowed_origins' => [
        'https://cartpage-g20s.onrender.com',  // Your frontend domain
        // Add more allowed domains here if needed
    ],

    // Optionally, use patterns to allow multiple domains dynamically (using regex).
    'allowed_origins_patterns' => [],

    // Define which headers are allowed in CORS requests (e.g., Content-Type, Authorization, etc.)
    'allowed_headers' => ['*'],  // Allows all headers

    // Define which headers should be exposed to the browser (optional).
    'exposed_headers' => [],

    // Set how long the results of a preflight request (OPTIONS) can be cached.
    'max_age' => 0,

    // Set whether credentials (cookies, authorization headers) are allowed.
    'supports_credentials' => true,  // Set to true if your requests include credentials (e.g., cookies)
];

