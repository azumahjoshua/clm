export default async function auth(context) {
    const { req } = context;
    const user = req.session.user; // Changed from req.session.get()

    if (!user) {
        return {
            redirect: {
                destination: '/',
                permanent: false,
            },
        };
    }

    const configBundle = {
        user: req.session.user,
        apiToken: req.session.api_token,
        backendUrl: process.env.BACKEND_API_HOST + "/api",
        hostUrl: process.env.BACKEND_API_HOST,
        authHeader: { "Authorization": "Bearer " + req.session.api_token }
    };

    return {
        props: {
            user: req.session.user,
            api_token: req.session.api_token,
            configBundle: configBundle,
        },
    };
}

export async function unSecureAuth(context) {
    const { req } = context;
    const user = req.session.user;

    if (!user) {
        return {
            redirect: {
                destination: '/',
                permanent: false,
            },
        };
    }

    const configBundle = {
        user: req.session.user,
        apiToken: req.session.api_token,
        backendUrl: process.env.BACKEND_API_HOST + "/api",
        authHeader: { "Authorization": "Bearer " + req.session.api_token }
    };

    return {
        props: {
            user: req.session.user,
            apiToken: req.session.api_token,
            backendUrl: process.env.BACKEND_API_HOST + "/api",
            configBundle: configBundle
        },
    };
}

export async function authGuard(context) {
    const { req } = context;
    const user = req.session.user;

    if (user) {
        return {
            redirect: {
                destination: '/dashboard',
                permanent: false,
            },
        };
    }

    return {
        props: {
            url: process.env.BACKEND_API_HOST
        },
    };
}

// import {useRouter} from 'next/router'

// export default async function auth({req, res}) {
//     const user = req.session.get('user')

//     if (!user) {
//         return {
//             redirect: {
//                 destination: '/',
//                 permanent: false,
//             },
//         }
//     }


//     let configBundle = {
//         user: req.session.get('user'),
//         apiToken: req.session.get('api_token'),
//         backendUrl: process.env.BACKEND_API_HOST + "/api",
//         hostUrl: process.env.BACKEND_API_HOST,
//         authHeader: {"Authorization": "Bearer " + req.session.get('api_token')}
//     }

//     return {
//         props: {
//             user: req.session.get('user'),
//             api_token: req.session.get('api_token'),
//             configBundle: configBundle,
//         },
//     }
// }


// export async function unSecureAuth({req, res}) {
//     const user = req.session.get('user')

//     if (!user) {
//         return {
//             redirect: {
//                 destination: '/',
//                 permanent: false,
//             },
//         }
//     }

//     let configBundle = {
//         user: req.session.get('user'),
//         apiToken: req.session.get('api_token'),
//         backendUrl: process.env.BACKEND_API_HOST + "/api",
//         authHeader: {"Authorization": "Bearer " + req.session.get('api_token')}
//     }
//     return {
//         props: {
//             user: req.session.get('user'),
//             apiToken: req.session.get('api_token'),
//             backendUrl: process.env.BACKEND_API_HOST + "/api",
//             configBundle: configBundle
//         },
//     }
// }


// export async function authGuard({req, res}) {
//     const user = req.session.get('user')

//     // redirect to dashboard if user is already logged in.
//     if (user) {
//         return {
//             redirect: {
//                 destination: '/dashboard',
//                 permanent: false,
//             },
//         }
//     }

//     return {
//         props: {
//             url: process.env.BACKEND_API_HOST
//         },
//     }

// }
