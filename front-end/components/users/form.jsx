import {useContext, useEffect, useState, useCallback} from "react";
import FormError from "@/components/form-error";
import Link from "next/link";
import axios from "axios";
import {AppContext} from "@/components/context";
import {errorAlert, successAlert} from "@/lib/alerts";

export default function Form(props) {
    const config = useContext(AppContext);
    const [formData, setFormData] = useState({
        phone: "",
        email: "",
        username: "",
        firstname: "",
        lastname: ""
    });
    const [errors, setErrors] = useState({});
    const [isProcessing, setIsProcessing] = useState(false);

    const resetData = useCallback(() => {
        setFormData({
            username: "",
            firstname: "",
            lastname: "",
            email: "",
            phone: ""
        });
    }, []);

    const initData = useCallback((data) => {
        setFormData({
            username: data.username || "",
            firstname: data.first_name || "",
            lastname: data.last_name || "",
            email: data.email || "",
            phone: data.phone || ""
        });
    }, []);

    const handleError = useCallback((err) => {
        let message = "Oops! Something went wrong";
        if (err.response?.status === 422) {
            setErrors(err.response.data.errors || {});
            message = err.response.data.message || message;
        } else if (err.response?.data?.message) {
            message = err.response.data.message;
        }

        console.error(err);
        errorAlert("Error", message);
    }, []);

    const processStore = useCallback(async (data) => {
        try {
            const response = await axios.post(`${config.backendUrl}/admin/users`, data, {
                headers: {
                    ...config.authHeader,
                    'Content-Type': 'multipart/form-data'
                }
            });
            if (response.status === 201) {
                successAlert();
                resetData();
            }
        } catch (err) {
            handleError(err);
            throw err;
        }
    }, [config, resetData, handleError]);

    const processUpdate = useCallback(async (data) => {
        try {
            const response = await axios.patch(
                `${config.backendUrl}/users/${props.initData.id}`, 
                data,
                { headers: config.authHeader }
            );
            if (response.status === 200) {
                successAlert("Success!", "Operation was successful!");
            }
        } catch (err) {
            handleError(err);
            throw err;
        }
    }, [config, props.initData?.id, handleError]);

    const processData = useCallback(async () => {
        setIsProcessing(true);
        setErrors({});

        try {
            const data = {
                username: formData.username,
                first_name: formData.firstname,
                last_name: formData.lastname,
                email: formData.email,
                phone: formData.phone,
            };

            if (props.initData) {
                await processUpdate(data);
            } else {
                await processStore(data);
            }
        } catch (err) {
            // Error already handled in processStore/processUpdate
        } finally {
            setIsProcessing(false);
        }
    }, [formData, props.initData, processStore, processUpdate]);

    useEffect(() => {
        if (props.initData) {
            initData(props.initData);
        }
    }, [props.initData, initData]);

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
                                <span className="label-text">Username</span>
                            </div>
                            <input
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.username && 'input-error'}`}
                                value={formData.username}
                                onChange={handleInputChange('username')}
                                placeholder="Type username"
                                required
                            />
                            <FormError error={errors.username}/>
                        </label>
                        <div className="my-2">
                            <hr/>
                        </div>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">First Name</span>
                            </div>
                            <input
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.first_name && 'input-error'}`}
                                value={formData.firstname}
                                onChange={handleInputChange('firstname')}
                                placeholder="Type first name"
                                required
                            />
                            <FormError error={errors.first_name}/>
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Last Name</span>
                            </div>
                            <input
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.last_name && 'input-error'}`}
                                value={formData.lastname}
                                onChange={handleInputChange('lastname')}
                                placeholder="Type last name"
                                required
                            />
                            <FormError error={errors.last_name}/>
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Email</span>
                            </div>
                            <input
                                type="email"
                                className={`input input-bordered flex items-center gap-2 ${errors.email && 'input-error'}`}
                                value={formData.email}
                                onChange={handleInputChange('email')}
                                placeholder="Type email address"
                                required
                            />
                            <FormError error={errors.email}/>
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Phone</span>
                            </div>
                            <input
                                type="text"
                                className={`input input-bordered flex items-center gap-2 ${errors.phone && 'input-error'}`}
                                value={formData.phone}
                                onChange={handleInputChange('phone')}
                                placeholder="Type phone number"
                                required
                            />
                            <FormError error={errors.phone}/>
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
                <Link href="/users" className="btn btn-neutral border-0 hover:text-white">
                    Cancel
                </Link>
            </div>
        </>
    )
}