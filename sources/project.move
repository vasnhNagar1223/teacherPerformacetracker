module TeacherTracker::PerformanceTracker {
    use std::signer;
    use std::vector;

    /// Struct to represent a teacher's performance record
    struct TeacherRecord has store, key {
        /// Total rating points accumulated
        total_rating_points: u64,
        /// Number of ratings received
        total_ratings: u64,
        /// List of individual ratings
        rating_history: vector<u64>
    }

    /// Function to initialize a teacher's performance tracking
    public fun initialize_teacher(teacher: &signer) {
        let record = TeacherRecord {
            total_rating_points: 0,
            total_ratings: 0,
            rating_history: vector::empty()
        };
        move_to(teacher, record);
    }

    /// Function to add a rating for a teacher (1-5 scale)
    public fun add_teacher_rating(
        rater: &signer, 
        teacher_address: address, 
        rating: u64
    ) acquires TeacherRecord {
        // Validate rating is between 1 and 5
        assert!(rating >= 1 && rating <= 5, 1);

        let teacher_record = borrow_global_mut<TeacherRecord>(teacher_address);
        
        // Update rating statistics
        teacher_record.total_rating_points = teacher_record.total_rating_points + rating;
        teacher_record.total_ratings = teacher_record.total_ratings + 1;
        
        // Add rating to history
        vector::push_back(&mut teacher_record.rating_history, rating);
    }
}