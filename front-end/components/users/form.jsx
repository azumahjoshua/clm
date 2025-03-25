import { useContext, useEffect, useState } from "react";
import FormError from "@/components/form-error";
import Link from "next/link";
import axios from "axios";
import { AppContext } from "@/components/context";
import { errorAlert, successAlert } from "@/lib/alerts";

export default function Form(props) {
    const config = useContext(AppContext);

    const [formData, setFormData] = useState({
        username: "",
        first_name: "",
        last_name: "",
        email: "",
        phone: "",
    });

    const [errors, setErrors] = useState({});
    const [isProcessing, setIsProcessing] = useState(false);

    const resetData = () => {
        setFormData({
            username: "",
            first_name: "",
            last_name: "",
            email: "",
            phone: "",
        });
    };

    const initData = (data) => {
        setFormData({
            username: data.username,
            first_name: data.first_name,
            last_name: data.last_name,
            email: data.email,
            phone: data.phone,
        });
    };

    const handleError = (err) => {
        let message = "Oops! Something went wrong";
        if (err.response && err.response.status === 422) {
            setErrors(err.response.data.errors);
            message = err.response.data.message;
        }

        if (err.response) {
            message = err.response.data.message ?? "Oops! Something went wrong";
        }

        console.error(err);
        errorAlert("Oops! ", message);
    };

    const processData = async () => {
        setIsProcessing(true);
        setErrors({});

        try {
            const data = {
                username: formData.username,
                first_name: formData.first_name,
                last_name: formData.last_name,
                email: formData.email,
                phone: formData.phone,
            };

            props.initData ? await processUpdate(data) : await processStore(data);
        } catch (err) {
            handleError(err);
        }

        setIsProcessing(false);
    };

    const processStore = async (formData) => {
        const response = await axios.post(`${config.backendUrl}/admin/users`, formData, {
            headers: { ...config.authHeader, "Content-Type": "multipart/form-data" },
        });

        if (response.status === 201) {
            successAlert("Success!", "User created successfully!");
            resetData();
        }
    };

    const processUpdate = async (formData) => {
        const response = await axios.patch(`${config.backendUrl}/users/${props.initData.id}`, formData, {
            headers: { ...config.authHeader },
        });

        if (response.status === 200) {
            successAlert("Success!", "User updated successfully!");
        }
    };

    useEffect(() => {
        if (props.initData) {
            initData(props.initData);
        }
    }, [props.initData]); // Add props.initData as a dependency

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({
            ...prev,
            [name]: value,
        }));
    };

    return (
        <>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 my-4">
                <div>
                    <form>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Username</span>
                            </div>
                            <input
                                type="text"
                                name="username"
                                className={`input input-bordered flex items-center gap-2 ${errors.username && "input-error"}`}
                                value={formData.username}
                                onChange={handleChange}
                                placeholder="Type username"
                                required
                            />
                            <FormError error={errors.username} />
                        </label>
                        <div className="my-2">
                            <hr />
                        </div>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">First Name</span>
                            </div>
                            <input
                                type="text"
                                name="first_name"
                                className={`input input-bordered flex items-center gap-2 ${errors.first_name && "input-error"}`}
                                value={formData.first_name}
                                onChange={handleChange}
                                placeholder="Type first name"
                                required
                            />
                            <FormError error={errors.first_name} />
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Last Name</span>
                            </div>
                            <input
                                type="text"
                                name="last_name"
                                className={`input input-bordered flex items-center gap-2 ${errors.last_name && "input-error"}`}
                                value={formData.last_name}
                                onChange={handleChange}
                                placeholder="Type last name"
                                required
                            />
                            <FormError error={errors.last_name} />
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Email</span>
                            </div>
                            <input
                                type="email"
                                name="email"
                                className={`input input-bordered flex items-center gap-2 ${errors.email && "input-error"}`}
                                value={formData.email}
                                onChange={handleChange}
                                placeholder="Type email address"
                                required
                            />
                            <FormError error={errors.email} />
                        </label>
                        <label className="form-control">
                            <div className="label">
                                <span className="label-text">Phone</span>
                            </div>
                            <input
                                type="text"
                                name="phone"
                                className={`input input-bordered flex items-center gap-2 ${errors.phone && "input-error"}`}
                                value={formData.phone}
                                onChange={handleChange}
                                placeholder="Type phone number"
                                required
                            />
                            <FormError error={errors.phone} />
                        </label>
                    </form>
                </div>
            </div>
            <div className="my-4 gap-2 flex">
                <button className="btn btn-primary" onClick={processData} disabled={isProcessing}>
                    {isProcessing && <span className="loading loading-spinner loading-md"></span>}
                    Save
                </button>
                <Link href="/users" className="btn btn-neutral border-0 hover:text-white">
                    Cancel
                </Link>
            </div>
        </>
    );
}