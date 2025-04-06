import {useContext, useEffect, useState, useCallback} from "react";
import axios from "axios";
import {errorAlert, successAlert, sweetConfirm} from "@/lib/alerts";
import {AppContext} from "@/components/context";
import Loader from "@/components/loader";
import UserView from "@/components/users/view";

export default function UsersIndex({users}) {
    const config = useContext(AppContext);
    const [isLoading, setIsLoading] = useState(true);
    const [data, setData] = useState([]);
    const [query, setQuery] = useState("");
    const [activeRecord, setActiveRecord] = useState(null);

    const fetchData = useCallback(async () => {
        setIsLoading(true);
        try {
            const response = await axios.get(`${config.backendUrl}/admin/users`, {
                headers: {...config.authHeader}
            });

            if (response.status === 200) {
                setData(response.data.data);
            }
        } catch (err) {
            console.error(err);
            errorAlert("Oops!", "Failed to fetch data.");
        } finally {
            setIsLoading(false);
        }
    }, [config]);

    const deleteDatum = useCallback(async (datum) => {
        try {
            const response = await axios.delete(`${config.backendUrl}/admin/users/${datum.id}`, {
                headers: {...config.authHeader}
            });

            if (response.status === 204) {
                setData(prev => prev.filter(item => item.id !== datum.id));
                setActiveRecord(null);
                successAlert("Deleted!", "User has been deleted successfully.");
            }
        } catch (err) {
            errorAlert("Oops!", "Something went wrong!");
        }
    }, [config]);

    const initDeletion = useCallback(async () => {
        if (!activeRecord) return;
        
        const confirmed = await sweetConfirm(
            "Delete this item?", 
            "You won't be able to undo this!"
        );

        if (confirmed) {
            await deleteDatum(activeRecord);
        }
    }, [activeRecord, deleteDatum]);

    useEffect(() => {
        fetchData();
    }, [fetchData]);

    const handleSearch = useCallback((e) => {
        setQuery(e.target.value);
        // Add search filtering logic here if needed
    }, []);

    const handleSelectRecord = useCallback((item) => {
        setActiveRecord(item);
    }, []);

    if (isLoading) {
        return <Loader loading={isLoading}/>;
    }

    return (
        <div className="grid grid-cols-3 gap-10">
            <div className="h-[35em] bg-white shadow-sm border">
                <div className="px-2 py-2">
                    <input 
                        type="search" 
                        className="input input-bordered w-full"
                        value={query}
                        onChange={handleSearch}
                        placeholder="Search..."
                    />
                </div>
                <div className="h-[25em] overflow-y-auto overscroll-auto">
                    {data.map((item) => (
                        <div 
                            onClick={() => handleSelectRecord(item)} 
                            key={item.id}
                            className={`list-group-item ${activeRecord?.id === item.id ? 'active' : ''}`}
                        >
                            <div className="flex justify-between">
                                <div>{item.name}</div>
                                {activeRecord?.id === item.id && (
                                    <div>
                                        <svg 
                                            xmlns="http://www.w3.org/2000/svg" 
                                            width={24} 
                                            height={24}
                                            viewBox="0 0 24 24" 
                                            fill="none" 
                                            stroke="currentColor"
                                            strokeWidth={1.25} 
                                            strokeLinecap="round" 
                                            strokeLinejoin="round"
                                            className="icon icon-tabler icons-tabler-outline icon-tabler-arrow-right-square"
                                        >
                                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                            <path d="M7 12l14 0"/>
                                            <path d="M18 15l3 -3l-3 -3"/>
                                            <path d="M3 10h4v4h-4z"/>
                                        </svg>
                                    </div>
                                )}
                            </div>
                        </div>
                    ))}
                </div>
            </div>
            <div className="col-span-2">
                <UserView 
                    datum={activeRecord} 
                    deleteCb={initDeletion}
                    onRefresh={fetchData}
                />
            </div>
        </div>
    )
}