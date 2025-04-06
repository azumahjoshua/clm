import { withSessionRoute } from '@/lib/session';
import axios from "axios";

export default withSessionRoute(async (req, res) => {
    const api_token = req.session.api_token; // Changed from .get()
    const user = req.session.user; // Changed from .get()

    if (!user) {
        return res.status(401).json({ isLoggedIn: false });
    }

    // Destroy session
    req.session.destroy();

    // Optional: Also destroy on the server
    // const response = await axios.post(apiUrl(`logout`), null, {
    //   headers: { Authorization: `Bearer ${api_token}` }
    // });

    return res.json({ isLoggedIn: false });
});

// import withSession from '@/lib/session'
// import axios from "axios";

// export default withSession(async (req, res) => {
//     const api_token = req.session.get('api_token');
//     const user = req.session.get('api_token');

//     if (!user) {
//         return res.json(401);
//     }

//     req.session.destroy();

//     // also destroy on the server
//     //todo
//     // const response = await axios.post(apiUrl(`logout`), null, {headers: {Authorization: `Bearer ${api_token}`}});

//     return res.json({isLoggedIn: false});

//     // if (response.status === 200) {
//     //     return res.json({isLoggedIn: false})
//     // }
//     //
//     // res.status(500).json({isLoggedIn: true})

// })
