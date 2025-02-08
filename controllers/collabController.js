const Request = require("../models/requestSchema");
const Collaboration = require("../models/colaborationSchema");
const Listing = require("../models/listingSchema");
const mongoose = require("mongoose");

exports.sendRequest = async (req, res) => {
  try {
    const { sender_id, senderType, receiver_id, receiverType } = req.body;

    const existingRequest = await Request.findOne({ sender_id, receiver_id, status: "pending" });
    if (existingRequest) return res.status(400).json({ message: "Request already sent." });

    const request = new Request({ sender_id, senderType, receiver_id, receiverType });
    await request.save();
    res.status(201).json({ message: "Request sent successfully!", request });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

exports.acceptRequest = async (req, res) => {
    try {
      const { requestId, userId, listingId } = req.body;
  
      // Check if the listingId is a valid ObjectId
      if (!mongoose.Types.ObjectId.isValid(listingId)) {
        return res.status(400).json({ message: "Invalid listingId format" });
      }
  
      // Convert the listingId to ObjectId if valid
      const validListingId = new mongoose.Types.ObjectId(listingId);
  
      // Fetch the request
      const request = await Request.findById(requestId);
      if (!request) {
        return res.status(404).json({ message: "Request not found" });
      }
  
      // Ensure the correct receiver is accepting the request
      if (request.receiver_id.toString() !== userId) {
        return res.status(403).json({ message: "Only the receiver can accept this request" });
      }
  
      // Update the request status to 'accepted'
      request.status = "accepted";
      await request.save();
  
      // Fetch the listing details using the valid ObjectId
      const listing = await Listing.findById(validListingId);
      if (!listing) {
        return res.status(404).json({ message: "Listing not found" });
      }
  
      // Create a new collaboration based on the request and listing details
      const collaboration = new Collaboration({
        corporate_id: request.senderType === "corporate" ? request.sender_id : request.receiver_id,
        ngo_id: request.senderType === "ngo" ? request.sender_id : request.receiver_id,
        status: "Active",
        funds_allocated: listing.funding_required || 0,  // Using the funding_required from Listing
        volunteers_involved: listing.volunteers_available || 0,  // Using the volunteers_available from Listing
        listing_title: listing.Title,
        listing_description: listing.Description,
        listing_created_time: listing.Created_time,
      });
  
      // Save the collaboration document
      await collaboration.save();
  
      // Send response
      res.json({
        message: "Request accepted! Collaboration created successfully.",
        request,
        collaboration,
      });
    } catch (error) {
      console.error("Error accepting request:", error);
      res.status(500).json({ message: "Server error", error });
    }
  };

exports.rejectRequest = async (req, res) => {
  try {
    const { requestId, userId } = req.body;
    const request = await Request.findById(requestId);
    if (!request) return res.status(404).json({ message: "Request not found" });

    if (request.receiver_id.toString() !== userId)
      return res.status(403).json({ message: "Only the receiver can reject this request" });

    request.status = "rejected";
    await request.save();
    res.json({ message: "Request rejected!", request });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};


exports.getAllPendingRequests = async (req, res) => {
  try {
    const requests = await Request.find({ status: "pending" });
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};


exports.getRequestsSentByUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const requests = await Request.find({ sender_id: userId });
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};


exports.getRequestsReceivedByUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const requests = await Request.find({ receiver_id: userId });
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};



// const Request = require("../models/requestSchema");
// const Collaboration = require("../models/colaborationSchema");




// exports.sendRequest = async (req, res) => {
//   try {
//     const { sender_id, senderType, receiver_id, receiverType } = req.body;

//     const existingRequest = await Request.findOne({ sender_id, receiver_id, status: "pending" });
//     if (existingRequest) return res.status(400).json({ message: "Request already sent." });

//     const request = new Request({ sender_id, senderType, receiver_id, receiverType });
//     await request.save();
//     res.status(201).json({ message: "Request sent successfully!", request });
//   } catch (error) {
//     res.status(500).json({ message: "Server error", error });
//   }
// };


// exports.acceptRequest = async (req, res) => {
//   try {
//     const { requestId, userId } = req.body;
//     const request = await Request.findById(requestId);
//     if (!request) return res.status(404).json({ message: "Request not found" });

//     if (request.receiver_id.toString() !== userId)
//       return res.status(403).json({ message: "Only the receiver can accept this request" });

//     request.status = "accepted";
//     await request.save();

//     const collaboration = new Collaboration({
//       corporate_id: request.senderType === "corporate" ? request.sender_id : request.receiver_id,
//       ngo_id: request.senderType === "ngo" ? request.sender_id : request.receiver_id,
//       status: "Active",
//       funds_allocated: 0,
//       volunteers_involved: 0,
//     });
//     await collaboration.save();

//     res.json({ message: "Request accepted! Collaboration created.", request, collaboration });
//   } catch (error) {
//     res.status(500).json({ message: "Server error", error });
//   }
// };


// exports.rejectRequest = async (req, res) => {
//   try {
//     const { requestId, userId } = req.body;
//     const request = await Request.findById(requestId);
//     if (!request) return res.status(404).json({ message: "Request not found" });

   
//     if (request.receiver_id.toString() !== userId)
//       return res.status(403).json({ message: "Only the receiver can reject this request" });

//     request.status = "rejected";
//     await request.save();
//     res.json({ message: "Request rejected!", request });
//   } catch (error) {
//     res.status(500).json({ message: "Server error", error });
//   }
// };

// exports.getAllRequests = async (req, res) => {
//   try {
//     const requests = await Request.find({ sender_status: "Pending", receiver_status: "Pending" });
//     res.json(requests);
//   } catch (error) {
//     res.status(500).json({ message: "Server error", error });
//   }
// };
