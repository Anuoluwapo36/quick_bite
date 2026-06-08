package com.quick_bite.model;

import java.sql.Timestamp;

public class Activity {
    private String type;
    private String details;
    private Timestamp date;
    private String status;

    public Activity(String type, String details, Timestamp date, String status) {
        this.type = type;
        this.details = details;
        this.date = date;
        this.status = status;
    }

    public String getType() { return type; }
    public String getDetails() { return details; }
    public Timestamp getDate() { return date; }
    public String getStatus() { return status; }
}
