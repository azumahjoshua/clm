import { withIronSession } from 'iron-session';

export const sessionOptions = {
  password: process.env.SECRET_COOKIE_PASSWORD,
  cookieName: 'clm.mw',
  cookieOptions: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    sameSite: 'lax',
    maxAge: 86400 // 1 day in seconds
  },
};

export const withSessionRoute = (handler) => {
  return withIronSession(handler, sessionOptions);
};

export const withSessionSsr = (handler) => {
  return async (context) => {
    return handler(context);
  };
};

// Backward compatibility
export default withSessionRoute;

// // Updated to use iron-session v6+ (replacement for next-iron-session)
// import { withIronSession } from 'iron-session';

// // Session configuration
// export const sessionOptions = {
//   password: process.env.SECRET_COOKIE_PASSWORD,
//   cookieName: 'clm.mw',
//   cookieOptions: {
//     secure: process.env.NODE_ENV === 'production',
//     // Add additional cookie options if needed:
//     // httpOnly: true,
//     // sameSite: 'lax',
//     // maxAge: 86400 // 1 day
//   },
// };

// // API Route wrapper
// export const withSessionRoute = (handler) => {
//   return withIronSession(handler, sessionOptions);
// };

// // getServerSideProps wrapper
// export const withSessionSsr = (handler) => {
//   return async (context) => {
//     const ironSession = await withIronSession(context.req, context.res, sessionOptions);
//     context.req.session = ironSession.req.session;
//     return handler(context);
//   };
// };
// this file is a wrapper with defaults to be used in both API routes and `getServerSideProps` functions
// import { withIronSession } from 'next-iron-session'

// export default function withSession(handler) {
//     return withIronSession(handler, {
//         password: process.env.SECRET_COOKIE_PASSWORD,
//         cookieName: 'clm.mw',
//         cookieOptions: {
//             secure: process.env.NODE_ENV === 'production',
//         },
//     })
// }
