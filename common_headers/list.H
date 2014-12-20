namespace xaxaxa
{
	template<class T>class list
	{
	public:
		struct _item {
			_item* prev;
			_item* next;
			T& operator*() {
				return *(T*)(this+1);
			}
		};
		struct iterator
		{
			_item* _;
			bool end() {
				return _==nullptr;
			}
			T& operator*() {
				return **_;
			}
			iterator& operator+=(int n) {
				for(int i=0;i<n;i++) {
					if(end()) break;
					_=_->next;
				}
				return *this;
			}
			iterator& operator-=(int n) {
				for(int i=0;i<n;i++) {
					if(end()) break;
					_=_->prev;
				}
				return *this;
			}
			void operator++(int) {
				if(!end())_=_->next;
			}
			void operator--(int) {
				if(!end())_=_->prev;
			}
			iterator(_item* it):_(it){}
			bool operator==(const iterator& other) {
				return _==other._;
			}
		};
		_item* _first;
		_item* _last;
		iterator begin() {
			return iterator(_first);
		}
		iterator end() {
			return iterator(nullptr);
		}
		iterator getIterator(T* obj) {
			return iterator(((_item*)obj)-1);
		}
		iterator first() {
			return begin();
		}
		iterator last() {
			return iterator(_last);
		}
		void push_back(const T& obj) {
			
		}
	};
};
