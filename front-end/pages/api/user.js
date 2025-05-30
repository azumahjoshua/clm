import { withSessionRoute } from '@/lib/session';

export default withSessionRoute(async (req, res) => {
    const user = req.session.user; // Changed from .get()

    if (user) {
        res.json({ isLoggedIn: true, ...user });
    } else {
        res.json({ isLoggedIn: false });
    }
});

// import withSession from '@/lib/session'

// export default withSession(async (req, res) => {
//     const user = req.session.get('user')

//     if (user) {
//         res.json({isLoggedIn: true, ...user,});
//     } else {
//         res.json({isLoggedIn: false,})
//     }
// })
