// types/session.d.ts
import 'iron-session';

declare module 'iron-session' {
  interface IronSessionData {
    user?: {
      id: string;
      email: string;
      username: string;
      first_name: string;
      last_name: string;
      phone?: string;  
      password?: never; 
    };
    api_token?: string;
  }
}