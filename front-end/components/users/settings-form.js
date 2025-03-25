import {useContext, useEffect, useState} from "react";
import FormError from "@/components/form-error";
import axios from "axios";
import {AppContext} from "@/components/context";
import Swal from "sweetalert2";

export default function SettingsForm(props) {
    const config = useContext(AppContext);
    const [phone, setPhone] = useState("");
    const [email, setEmail] = useState('');
    const [errors, setErrors] = useState({});
    const [isProcessing, setIsProcessing] = useState(false);

    useEffect(() => {
        if (props.initData) {
            setPhone(props.initData.phone || "");
            setEmail(props.initData.email || "");
        }
    }, [props.initData]); // Fixed: Added dependency

    const handleError = (err) => {
        let message = "Oops! Something went wrong";
        if (err.response && err.response.status === 422) {
            setErrors(err.response.data.errors);
            message = err.response.data.message;
        }
        console.error(err);
        Swal.fire('Error', message, 'error');
    }

    const processData = async () => {
        setIsProcessing(true);
        setErrors({});

        try {
            await processUpdate({
                phone,
                email,
            });
        } catch (err) {
            handleError(err);
        } finally {
            setIsProcessing(false);
        }
    }

    const updateInSession = async (updatedUser) => {
        try {
            await axios.post("/api/amend-user", {
                updated_user: updatedUser,
                api_token: config.apiToken
            });
        } catch (err) {
            console.error("Failed to update session:", err);
        }
    }

    const processUpdate = async (formData) => {
        const response = await axios.patch(
            `${config.backendUrl}/users/${props.initData.id}`, 
            formData, 
            { headers: {...config.authHeader} }
        );

        if (response.status === 200) {
            Swal.fire({
                title: 'Success!',
                text: 'Operation successfully completed.',
                icon: 'success',
                confirmButtonText: 'Ok'
            });
            await updateInSession(response.data.data);
        }
        return response;
    }

    return (
        <>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 my-4">
                <div>
                    <form>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Phone</span>
                            </div>
                            <input 
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.phone && 'input-error'}`}
                                value={phone}
                                onChange={(e) => setPhone(e.target.value)}
                                placeholder="Enter phone number" 
                                required
                            />
                            <FormError error={errors.phone}/>
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Email</span>
                            </div>
                            <input 
                                type="text"
                                className={`input input-bordered ${errors.email && 'input-error'}`}
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                placeholder="Type email address" 
                                required
                            />
                            <FormError error={errors.email}/>
                        </label>
                    </form>
                </div>
            </div>
            <div className="my-4 gap-2 flex">
                <button className="btn btn-primary" onClick={processData} disabled={isProcessing}>
                    {isProcessing && <span className="loading loading-spinner loading-md"></span>}
                    Save
                </button>
            </div>
        </>
    )
}