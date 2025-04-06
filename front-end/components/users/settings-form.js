import {useContext, useEffect, useState, useCallback} from "react";
import FormError from "@/components/form-error";
import axios from "axios";
import {AppContext} from "@/components/context";
import Swal from "sweetalert2";

export default function SettingsForm(props) {
    const config = useContext(AppContext);
    const [formData, setFormData] = useState({
        phone: "",
        email: ""
    });
    const [errors, setErrors] = useState({});
    const [isProcessing, setIsProcessing] = useState(false);

    const resetData = useCallback(() => {
        setFormData({
            phone: "",
            email: ""
        });
    }, []);

    const handleError = useCallback((err) => {
        let message = "Oops! Something went wrong";
        if (err.response?.status === 422) {
            setErrors(err.response.data.errors || {});
            message = err.response.data.message || message;
        }
        console.error(err);
        Swal.fire({
            title: 'Error',
            text: message,
            icon: 'error',
            confirmButtonText: 'Ok'
        });
    }, []);

    const updateInSession = useCallback(async (updatedUser) => {
        try {
            await axios.post("/api/amend-user", {
                updated_user: updatedUser,
                api_token: config.apiToken
            });
        } catch (err) {
            console.error("Session update error:", err);
            throw err;
        }
    }, [config.apiToken]);

    const processUpdate = useCallback(async (formData) => {
        try {
            const response = await axios.patch(
                `${config.backendUrl}/users/${props.initData.id}`, 
                formData,
                { headers: config.authHeader }
            );

            if (response.status === 200) {
                await updateInSession(response.data.data);
                Swal.fire({
                    title: 'Success!',
                    text: 'Operation successfully completed.',
                    icon: 'success',
                    confirmButtonText: 'Ok'
                });
            }
            return response;
        } catch (err) {
            handleError(err);
            throw err;
        }
    }, [config, props.initData?.id, handleError, updateInSession]);

    const processData = useCallback(async () => {
        setIsProcessing(true);
        setErrors({});

        try {
            await processUpdate({
                phone: formData.phone,
                email: formData.email
            });
        } catch (err) {
            // Error already handled in processUpdate
        } finally {
            setIsProcessing(false);
        }
    }, [formData, processUpdate]);

    useEffect(() => {
        if (props.initData) {
            setFormData({
                phone: props.initData.phone || "",
                email: props.initData.email || ""
            });
        }
    }, [props.initData]);

    const handleInputChange = (field) => (e) => {
        setFormData(prev => ({
            ...prev,
            [field]: e.target.value
        }));
    };

    return (
        <>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 my-4">
                <div>
                    <form onSubmit={(e) => e.preventDefault()}>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Phone</span>
                            </div>
                            <input
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.phone && 'input-error'}`}
                                value={formData.phone}
                                onChange={handleInputChange('phone')}
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
                                type="email"
                                className={`input input-bordered ${errors.email && 'input-error'}`}
                                value={formData.email}
                                onChange={handleInputChange('email')}
                                placeholder="Type email address"
                                required
                            />
                            <FormError error={errors.email}/>
                        </label>
                    </form>
                </div>
            </div>
            <div className="my-4 gap-2 flex">
                <button 
                    className="btn btn-primary" 
                    onClick={processData}
                    disabled={isProcessing}
                >
                    {isProcessing && <span className="loading loading-spinner loading-md"></span>}
                    Save
                </button>
            </div>
        </>
    )
}